module SideBarHelpers
	def generate_sidebar
		toc = Toc.new items
		render 'course_sidebar', toc: toc
	end
end