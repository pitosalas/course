module ContentHelpers

    def include_topic item_symbol
        incorporated_topic = symbol_to_item(item_symbol, :topics)
        Toc.instance.record_inclusion @item, incorporated_topic
        items[incorporated_topic.identifier].compiled_content
    end

    def symbol_to_item item_symbol, section_symbol
        the_item = items.select do
            |i| i.identifier.split("/").last == item_symbol.to_s && i.attributes[:section] == section_symbol.to_s
        end
        if the_item.nil? || the_item.length != 1
            raise "#{item.identifier}: invalid  link_to or incorporate #{section_symbol}: #{item_symbol.to_s}" if the_item.nil? || the_item == []
            raise "#{item.identifier}: duplicate identifier in link_to_#{section_symbol}: #{item_symbol.to_s}" if the_item.length != 1          
        end
        the_item[0]
    end

    def toc_link_to item
        link_to_unless_current item.attributes[:title], item
    end

    def bold_red string
        "**#{string}**{: style=\"color: red\"}"
    end


end

## **Note for first day of class:**{: style="color: red"} Each day of class has a page on this web site. The first section of that page is always the homework due on that very day. So in other words, the homework listed here is actually "pre-work" for day one. We will go over this in a little more detail during class.
