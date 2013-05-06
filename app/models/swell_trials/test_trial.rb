module SwellTrials
	class TestTrial < ActiveRecord::Base
		self.table_name = 'test_trials'
		attr_protected :none

		belongs_to 	:test
		belongs_to 	:test_variant
		belongs_to 	:guest, class_name: 'User', foreign_key: :guid


		def increment_view_count
			self.cached_view_count += 1 if self.updated_at > 1.minute.ago
			self.save
		end
		
	end
end