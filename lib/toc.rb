require 'singleton'
require 'pry'

class Toc
  include Enumerable
  include Singleton

  def prepare items
    raise "Toc.prepare called twice!" unless @tocs.nil?
    @tocs = {}
    @info = {}
    %i(topics intro incubator background lectures).each do
      |sect|
      build_section_toc(sect, items)
    end
  end

  def reset
    @tocs = nil
  end

  def build_section_toc sect, items
    @tocs[sect] = select_items_for_section sect, items
    @tocs[sect].sort! { |a,b| a[:order] <=> b[:order] }
  end

  def exclude_from_toc? item
    item[:status] == "hidden" || %w(css min.css js png).include?(item[:extension])
  end

  def each_by(section, &block)
    sub_toc = @tocs[section]
    sub_toc.sort! { |a,b| a[:order] <=> b[:order] }.each do |member|
      block.call(member)
    end
  end

  def select_items_for_section sect, items
    items.find_all do |item|
      item[:section] == sect.to_s && !exclude_from_toc?(item)
    end
  end

  def sort_section_by_order sect
      @tocs[sect].sort! { |a,b| a[:order] <=> b[:order] }
  end

  def sort_section_by_subsection_name(sect)
    items = @tocs[sect]
    items.sort! do
      |item1, item2|
      subsection_name(sect.to_s, item1.identifier) <=> subsection_name(sect.to_s, item2.identifier)
    end
    items
  end

  def subsections(section, &block)
    items = sort_section_by_subsection_name section
    item_iterator = items.chunk do |item|
      subsection_name section.to_s, item.identifier
    end
    item_iterator.each do |subsection_item|
      block.call(subsection_item)
    end
  end

  def subsection_name section_name, item_name
    item_matcher = item_name.match('\A/'+section_name+'/([^/]*)/([^/]*)/\z')
    if !item_matcher.nil?
      item_matcher[1]
    else
      ""
    end
  end

  def find_next_for(item)
    sect = section_for_item(item)
    sort_section_by_order sect
    index = index_in_section(item)
    lookup_by_index(sect, index + 1)
  end

  def find_previous_for(item)
    sect = section_for_item(item)
    sort_section_by_order sect
    index = index_in_section(item)
    lookup_by_index(sect, index - 1)
  end

  def record_inclusion host_item, included_item
    @info[included_item.identifier] = host_item
  end

  def lookup_inclusion included_item
    @info[included_item.identifier]
  end

  def lookup_by_index section, index
    if index >= @tocs[section].length
      index = @tocs[section].length-1
    elsif index < 0
      index = 0
    end
    @tocs[section][index]
  end

  def section_for_item item
    item[:section].to_sym rescue binding.pry
  end

  def index_in_section item
    sect = section_for_item item
    index = @tocs[sect].find_index(item)
  end

end
