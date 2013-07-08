class Toc
	ItemInfo = Struct.new(:item, :depth, :start_block, :end_block, :block_change)
	include Enumerable

	def initialize items
		build_toc items
	end

	def build_toc items
		@toc = items.map{ |i| ItemInfo.new(i, 0) }
		@toc.delete_if { |info| %w(css min.css js min.js png).include? info.item.attributes[:extension] }
		@toc.delete_if { |info| info.item.attributes[:status] ==  "hidden" }
		@toc.delete_if { |info| info.item.attributes[:section] == "topics" }

		@toc.each { |info| info.depth = info.item.identifier.split("/").count}
		@toc.sort! do |a,b|
			res = a.depth <=> b.depth
			# Catch badly formatted content.
			if a.item.nil? || b.item.nil? || a.item.attributes[:title].class != String || b.item.attributes[:title].class != String
				binding.pry
			else
				res == 0 ? a.item.attributes[:title] <=> b.item.attributes[:title] : res
			end
		end

		depth = -1
		@toc.each do |info|
			info.start_block = (info.depth > depth)
			info.end_block = (info.depth < depth)
			info.block_change = (info.depth - depth)
			depth = info.depth
		end
	end

  def each(&block)
    @toc.each do |member|
      block.call(member)
    end
  end
end

