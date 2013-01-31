jQuery ->
	if $(".pagination").length
		$(window).scroll ->			
			url = $(".pagination .next_page").attr("href")
			if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50)	
				$(".pagination").text(" Загрузка новых событий... ")
				$.getScript(url + '&' + $('form#filter').serialize())
		$(window).scroll()	