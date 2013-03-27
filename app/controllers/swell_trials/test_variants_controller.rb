module SwellTrials
	class TestVariantsController < ApplicationController
		before_filter :get_test

		def create
			authorize! :create, SwellTrials::TestVariant
			@variant = @test.test_variants.create( params[:test_variant] )
			if @variant.save
				pop_flash "Variant #{@variant.name} created."
				redirect_to edit_test_test_variant_path( @test, @variant )
			else
				pop_flash "Variant could not be created", :error, @variant
				redirect_to admin_tests_path
			end
		end

		def destroy
			
		end

		def edit
			authorize! :edit, SwellTrials::TestVariant
			@variant = @test.test_variants.find( params[:id] )
			render layout: 'admin'
		end

		def show
			authorize! :edit, SwellTrials::TestVariant
			@variant = @test.test_variants.find( params[:id] )
		end

		def update
			authorize! :edit, SwellTrials::TestVariant
			@variant = @test.test_variants.find( params[:id] )
			if @variant.update_attributes( params[:test_variant] )
				pop_flash "Variant Updated"
			else
				pop_flash "Variant could not be updated", :error, @variant
			end
			redirect_to :back
		end

		private

			def get_test
				@test = Test.where( site_id: @current_site.id ).find( params[:test_id] )
			end

	end
end