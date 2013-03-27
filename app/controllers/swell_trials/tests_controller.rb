module SwellTrials
	class TestsController < ApplicationController

		def admin
			authorize! :admin, SwellTrials::Test
			@tests = Test.where( site_id: @current_site.id )
			render layout: 'admin'
		end

		def create
			authorize! :create, SwellTests::Test
			@test = Test.new( params[:test] )
			@test.site_id = @current_site.id
			@test.user_id = @current_user.id

			if @test.save
				pop_flash "Test #{@test.name} created."
				redirect_to edit_test_path( @test )
			else
				pop_flash "Test could not be saved", :error, @test
				render :new
			end
		end

		def edit
			authorize! :edit, SwellTests::Test
			@test = Test.where( site_id: @current_site.id ).find( params[:id] )
			@paths = AppEvent.select( 'distinct path' ).where( event: 'view' ).collect{ |p| p.path }
			@confidence = params[:confidence] || '95'
			render layout: 'admin'
		end

		def show
			# check to see if we're running a root (homepage) test
			id = params[:id] || 'homepage'
			scope = Test.where( site_id: @current_site.id, status: 'published' )
			if @test = scope.where( id: id ).first || scope.where( slug: id ).first
				# no valid test if no active variants
				bail_to_swell_media( id: id ) if @test.active_variants.empty?
				# find or initialize a trial for the current_user
				trial = TestTrial.where( test_id: @test.id, guid: cookies[:guid] ).first_or_initialize
				if trial.id.present?
					@variant = trial.test_variant
					trial.increment_view_count if trial.updated_at < 1.minute.ago
				else
					# pick a variant
					@variant = @test.choose_variant
					unless @current_user.is_bot?
						trial.test_variant_id = @variant.id
						trial.save
						@variant.increment_participant_count
					end
				end
				record_app_event( :view, on: @variant, rate: 1.hour, content: "viewed #{@variant.name}" )
			else
				bail_to_swell_media( id )
			end
		end

		def update
			authorize! :edit, SwellTrials::Test
			@test = Test.where( site_id: @current_site.id ).find( params[:id] )
			if @test.update_attributes( params[:test] )
				pop_flash "Test #{@test.name} Updated"
			else
				pop_flash "Test could not be updated", :error, @test
			end
			redirect_to :back
			
		end



		private

			def bail_to_swell_media( id )
				redirect_to swell_media.media_path( id: id )
				return false
			end

	end
end