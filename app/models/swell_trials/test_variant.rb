module SwellTrials
	class TestVariant < ActiveRecord::Base
		self.table_name = 'test_variants'
		attr_protected :none

		validate :name, uniqueness: { scope: :test_id }

		belongs_to 	:test

		has_many	:test_trials, dependent: :destroy
		has_many	:guests, through: :test_trials



		def confidence_interval_for( args={} )
			return 'N/A' if self.cached_participant_count == 0 || self.test_trials.empty?

			args[:confidence] ||= '95' # 95% confidence

			confidence_factors = { '67' => 1, '75' => 1.15, '80' => 1.28, '90' => 1.645, '95' => 1.96, '99' => 2.575, '999' => 5 }

			confidence = confidence_factors[ args[:confidence] ] || 1.96

			# return Math.sqrt( self.conversion_rate_for( args ) * ( 1 - self.conversion_rate_for( args ) ) / self.cached_participant_count.to_f ) * confidence
			return Math.sqrt( self.conversion_rate_for( args ) * ( 1 - self.conversion_rate_for( args ) ) / self.cached_participant_count ) * confidence
		end

		def conversions_for( args={} )
			return 'N/A' if self.test_trials.empty?
			conversions = AppEvent.select( 'distinct guid' ).where( site_id: self.test.site_id, event: args[:event], guid: self.guests )
			conversions = conversions.where( "created_at > ?", self.first_trial.created_at )
			conversions = conversions.where( path: args[:path] ) if self.test.conversion_event == 'view' && args[:path].present?
			conversions = conversions.count
		end

		def conversion_rate_for( args={} )
			return 'N/A' if self.cached_participant_count == 0
			conversions = self.conversions_for( args )
			return ( conversions.to_f / self.cached_participant_count.to_f )
		end

		def first_trial
			self.test_trials.order( 'created_at asc' ).first
		end

		def increment_participant_count
			self.cached_participant_count += 1
			self.save
		end

		def primary_conversion_rate
			return 0 if self.cached_participant_count == 0 || self.cached_conversion_count == 0
			return self.cached_conversion_count / self.cached_participant_count 
		end



	end
end