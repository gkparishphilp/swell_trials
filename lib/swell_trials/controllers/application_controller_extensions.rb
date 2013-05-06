module SwellTrials
	module ApplicationControllerExtensions
		
		def set_participant
			if request.user_agent.present? && request.user_agent.match( /bot|spider|wget|feed|indexer|lwp-trivial|curl|libwww-perl|slurp|wordpress|zyborg|pinger|crawler/i )
				return false
			else
				cookies[:pid] = Time.now # TODO - random hash or record in db
			end
		end

	end

end