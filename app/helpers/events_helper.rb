module EventsHelper
	def sort_array_events(array_events)
		new_array = []
		arr = []
		array_events.each do |event|
			if not event.class.name.eql?('Month')
				arr += event.to_a
			 else
			 	arr.sort_by! {|e| e.start_date}				
			 	new_array += arr
			 	new_array += event.to_a
			 	arr = []
			end
		end		
		arr.sort_by! {|e| e.start_date}		
		new_array += arr
	end
end
