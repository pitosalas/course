module NavigationHelpers

  def link_to_lecture item_symbol
    link_to_generic item_symbol, :lectures
  end

  def link_to_topic item_symbol
    link_to_generic item_symbol, :topics
  end

  def link_to_background item_symbol
    link_to_generic item_symbol, :background
  end

  def link_to_intro item_symbol
    link_to_generic item_symbol, :intro
  end

  def link_to_incubator item_symbol
    link_to_generic item_symbol, :incubator
  end

  def link_to_generic item_symbol, section_symbol
    the_item = symbol_to_item item_symbol, section_symbol
		link_to_unless_current(the_item[:title], the_item.identifier)
  end

	def link_to_next toc, item
		nav_markup "next", toc.find_next_for(item).path, "icon-arrow-right"
	end

	def link_to_prev toc, item
		nav_markup "prev", toc.find_previous_for(item).path, "icon-arrow-left"
	end

	def link_to_inclusion item
		inclusion = Toc.instance.lookup_inclusion(item)
		if inclusion.nil?
			"(never included)"
		else
			" (#{inclusion.identifier})"
		end
	end

	private

	def nav_markup text, path, icon
		"<a class=\"btn btn-mini\" href=\"#{path}\"><i class=\"#{icon}\"></i>#{text}</a>"
	end

end
