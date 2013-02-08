module UsersHelper
	def find_with_facebook(f_id)
		User.all.to_a.each do |user|
			if user.connection.facebook_id == f_id
				puts user
				user
			end
		end
	end
	def find_with_vkontakte(v_id)

	end
end