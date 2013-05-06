class SwellTrialsMigration < ActiveRecord::Migration

	def change

		create_table :tests, force: true do |t|
			t.references 		:site
			t.references		:user 										# the admin who created the test
			t.string			:name
			t.string			:sample_type,				default: :coinflip
			t.text				:description
			t.string			:conversion_event,			default: :optin # default event to watch for in app_events table.. optin, etc.
			t.string			:conversion_path 							# path to scope for if event is view e.g. event:view path:'/faq'
			t.string			:status,					default: :published
			t.string 			:slug
			t.timestamps
		end

		add_index :tests, :site_id
		add_index :tests, :user_id
		add_index :tests, :name
		add_index :tests, [ :slug, :site_id ], 			unique: true


		create_table :test_variants, force: true do |t|
			t.references 		:test
			t.string			:name
			t.text				:description
			t.string			:variant_type,				default: :page
			t.integer			:weight,					default: 1
			t.text 				:content
			t.string			:status,					default: :published
			t.integer			:cached_participant_count, 	default: 0
			t.integer			:cached_conversion_count, 	default: 0
			t.timestamps
		end

		add_index :test_variants, :test_id
		add_index :test_variants, :name
		add_index :test_variants, [ :name, :test_id ]


		create_table :test_trials, force: true do |t|
			t.references 		:test
			t.references 		:test_variant
			t.integer			:participant_id
			t.integer			:cached_view_count, 		default: 1
			t.timestamps
		end

		add_index :test_trials, :test_variant_id
		add_index :test_trials, :participant_id

	end
end
