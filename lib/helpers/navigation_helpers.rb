module NavigationHelpers
	def link_to_next toc, item
		nav_markup "next", toc.find_next_for(item).path, "icon-arrow-right"
	end

	def link_to_prev toc, item
		nav_markup "prev", toc.find_previous_for(item).path, "icon-arrow-left"
#		link_to "prev", toc.find_previous_for(item)
	end

	private

	def nav_markup text, path, icon
		"<a class=\"btn btn-mini\" href=\"#{path}\"><i class=\"#{icon}\"></i>#{text}</a>"
	end

end