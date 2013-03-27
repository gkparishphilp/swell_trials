SwellTrials::Engine.routes.draw do
	root :to => 'tests#show'

	resources :tests do
		collection do
			get 'admin'
		end
		resources :test_variants
		resources :test_trials
	end

	

	# set root route to field any media
	match '/:id', :to => 'tests#show', :via => :get
end
