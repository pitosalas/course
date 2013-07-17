require 'singleton'

class Toc
	include Enumerable
	include Singleton

	def prepare items
		raise "Toc.prepare called twice!" unless @tocs.nil?
		@tocs = {}
		@info = {}
		%i(topics intro background lectures).each { |section| @tocs[section] = build_section_toc(section, items) }
	end

	def build_section_toc section, items
		section_toc = items.find_all do |item|
			item.attributes[:section] == section.to_s && !exclude_from_toc?(item)
		end
 		section_toc.sort { |a,b| a.attributes[:order] <=> b.attributes[:order] }
	end

	def exclude_from_toc? item
		item.attributes[:status] == "hidden" || %w(css min.css js png).include?(item.attributes[:extension])
	end

  def each_by(section, &block)
  	sub_toc = @tocs[section]
 		sub_toc.each do |member|
	 		block.call(member)
	 	end
  end

  def find_next_for(item)
  	sub_toc = @tocs[item.attributes[:section].to_sym] rescue binding.pry
  	index = sub_toc.find_index(item)
  	sub_toc[index == sub_toc.length - 1 ? index : index + 1]
  end

  def find_previous_for(item)
  	sub_toc = @tocs[item.attributes[:section].to_sym] rescue binding.pry
  	index = sub_toc.find_index(item)
		sub_toc[index == 0 ? 0 : index - 1]
  end

  def record_inclusion host_item, included_item
  	binding.pry
  	@info[included_item.identifier] = host_item
  end

  def lookup_inclusion included_item
  	binding.pry
  	@info[included_item.identifier]
  end
end

