class PaginationListLinkRenderer < WillPaginate::ActionView::LinkRenderer

protected

	def previous_page
	  num = @collection.current_page > 1 && @collection.current_page - 1
	  previous_or_next_page(num, @options[:previous_label], 'page_pre')
	end
	
	def next_page
	  num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
	  previous_or_next_page(num, @options[:next_label], 'page_next')
	end
	
	def previous_or_next_page(page, text, classname)
	if page
	  link(text, page, :class => classname)
	else
	  link(text, '#', :class => classname + '_no')
	end
	end
	
end
