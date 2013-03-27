module SwellTrials
	class Test < ActiveRecord::Base
		self.table_name = 'tests'

		attr_protected :none
		attr_accessor :url

		validate :name, uniqueness: { scope: :site_id }


		belongs_to 	:site

		has_many	:test_variants, dependent: :destroy
		has_many 	:test_trials, dependent: :destroy


		extend FriendlyId
	  	friendly_id :slugger, :use => :scoped, :scope => :site_id


	  	def active_variants
	  		self.test_variants.where( status: 'published' )
	  	end

	  	def choose_variant
	  		case self.sample_type
	  		when 'weighted'
	  			# todo
	  		when 'boatrace'
	  			self.active_variants.order( 'cached_participant_count desc' ).first
	  		else # coinflip
	  			self.active_variants[ rand( self.active_variants.size ) ]
	  		end
	  	end

	  	def participant_count
	  		self.test_variants.sum( :cached_participant_count )
	  	end

	  	def slugger
	  		self.url.present? ? self.url : self.name
	  	end

	end
end