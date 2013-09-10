module ContentHelpers

    def include_topic item_symbol
        incorporated_topic = symbol_to_item(item_symbol, :topics)
        Toc.instance.record_inclusion @item, incorporated_topic
        items[incorporated_topic.identifier].compiled_content
    end

    def include_image string, options=nil
        "<img src=\"/graphics/#{string}\" class=\"img-polaroid\">"
    end

    def symbol_to_item item_symbol, section_symbol
        the_item = items.select do
            |i| i.identifier.split("/").last == item_symbol.to_s && i[:section] == section_symbol.to_s
        end
        if the_item.nil? || the_item.length != 1
            raise "#{item.identifier}: invalid item referenced for #{section_symbol}: #{item_symbol.to_s}" if the_item.nil? || the_item == []
            raise "#{item.identifier}: duplicate item referenced for #{section_symbol}: #{item_symbol.to_s}" if the_item.length != 1
        end
        the_item[0]
    end

    def link_to_doc label, file_name
        "<a href=\"/docs/#{file_name}\">#{label}</a>"
    end

    def toc_link_to item
        link_to_unless_current item[:title], item
    end

    def bold_red string
        "**#{string}**{: style=\"color: red\"}"
    end

    def important string
        "**Important: #{string}**{: style=\"color: red\"}"
    end

    def tbd string=""
        "*[TO BE DETERMINED#{string}]*{: style=\"color: red\"}"
    end

    def deliverable string
        "*Deliverable:*{: style=\"color: red\"} *#{string}*"
    end

    def team_deliverable string
        "*Team Deliverable:*{: style=\"color: red\"} *#{string}*"
    end

    def discussion string
        "*Discussion:*{: style=\"color: blue\"} *#{string}*"
    end

    def carousel(filenames)
        body = %~<div id="myCarousel" class="carousel slide" style="width: 500px; margin: 0 auto;">
                <div class="carousel-inner" style="margin: 20px; ">~
        counter = 0
        filenames.each do
            |nam|
            if counter == 0
                body << %~<div class="item active">~
            else
                body << %~<div class="item">~
            end
            body << %~<img src="~
            body << "/graphics/#{nam}"
            body << %~" class="img-polaroid" alt=""></div>~
            counter += 1
        end
        body << %~</div> <a class="left carousel-control" href="#myCarousel" data-slide="prev">‹</a>
                    <a class="right carousel-control" href="#myCarousel" data-slide="next">›</a>
                </div>~
        body
    end
end
