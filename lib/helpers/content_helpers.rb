module ContentHelpers
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
        link_to_generic item_symbol, :background
    end

    def link_to_generic item_symbol, section_symbol
        the_item = symbol_to_item item_symbol, section_symbol
		link_to_unless_current(the_item.attributes[:title], the_item.identifier)
    end

    def incorporate_topic item_symbol
        a = items[symbol_to_item(item_symbol, :topics).identifier].compiled_content
    end

    def symbol_to_item item_symbol, section_symbol
        the_item = items.select do
            |i| i.identifier.split("/").last == item_symbol.to_s && i.attributes[:section] == section_symbol.to_s
        end
        if the_item.nil? || the_item.length != 1
            raise "invalid identifier in link_to or incorporate #{section_symbol}: #{item_symbol.to_s}" if the_item.nil? || the_item == []
            raise "duplicate identifier in link_to_#{section_symbol}: #{item_symbol.to_s}" if the_item.length != 1          
        end
        the_item[0]
    end

    def toc_link_to item
        link_to_unless_current item.attributes[:title], item
    end
end