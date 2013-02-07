module EventsHelper
	def sort_array_events(array_events)
		new_array = []
		arr = []
		array_events.each do |event|
			if not event.class.name.eql?('Month')
				arr << event
			else
				arr.sort_by! {|e| e.start_date}				
				new_array << arr
				new_array << event
				arr = []
			end
		end		
		arr.sort_by! {|e| e.start_date}
		#puts arr
		new_array << arr
	end
end
