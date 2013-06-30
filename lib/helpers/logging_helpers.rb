module LoggingHelpers
	def log_item_info
		puts
		puts "*** ITEM Info: #{item.identifier}"
		puts "Parent = #{item.parent}"
		puts "Children = #{item.children}"
		puts "Reps = #{item.reps}"
		pp item.attributes
	end
end