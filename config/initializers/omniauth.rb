Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '170537233084344', 'e55e5022043c935105604e861cc85654'
	provider :vkontakte, '3196496', 'ccKl4AuFmORpSm0wrb4M'
end