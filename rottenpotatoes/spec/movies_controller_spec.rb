require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'MoviesController' do
    movie1 = Movie.create(title: 'Bohemian Rhapsody', rating: 'PG-13', director: 'Bryan Singer', release_date: Date.new(2018,11,2))
    movie2 = Movie.create(title: 'X-Men', rating: 'PG-13', director: 'Bryan Singer', release_date: Date.new(2000,7,14))
    movie3 = Movie.create(title: 'To Be Decided', rating: 'PG', release_date: Date.new(2000,1,1))
    context 'Create movies' do
      before :each do
        @movies = Movie.all
      end

      it 'Should create a movie' do
        movies_count = Movie.all.count
        movie = {title: 'To Be Decided', rating: 'PG', release_date: Date.new(2000,1,1)}
        post :create, movie: movie

        expect(response).to redirect_to(movies_path)
        expect(@movies.count).to eq(movies_count + 1)
      end
    end

    context 'Edit movies' do
       before :each do
        @movies = Movie.all
      end

       it 'Should show the movie to be edited' do
         get :edit, id: @movies.take.id

         expect(assigns(:movie)).to eq(@movies.take)
       end

       it 'Should update the movie' do
         movie = @movies.take
         movie_param = {title: 'To Be Continued'}
         put :update, id: movie.id, movie: movie_param

         expect(response).to redirect_to(movie_path(movie.id))
         expect(Movie.find(movie.id).title).to eq('To Be Continued')
       end
    end

    context 'Destroy movies' do
       before :each do
        @movies = Movie.all
       end
       it 'Should destroy the movie' do
         movies_count = Movie.all.count
         movie = @movies.take
         delete :destroy, id: movie.id

         expect(response).to redirect_to(movies_path)
         expect(@movies.count).to eq(movies_count - 1)
       end
    end


    context 'Sort movies' do
      before :each do
        @movies = Movie.all
      end

      it 'Should be sorted by title' do
        get :index, sort: 'title'
      end
      it 'Should be sorted by release_date' do
        get :index, sort: 'release_date'
      end
      it 'Should show all movies' do
        get :index
      end
    end

    context 'List movies' do
      before :each do
        @movies = Movie.all
      end
      it 'Should list all moves' do
        get :show, id: @movies.take.id

        expect(assigns(:movie)).to eq(@movies.take)
      end
    end

        context "When specified movie has a director" do
            it "should find movies with the same director" do
                @movie_id = "1234"
                @movie = double('fake_movie', :director => 'James Cameron')

                expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
                expect(@movie).to receive(:find_director_movies)

                get :find_director, :id => @movie_id

                expect(response).to render_template(:find_director)
            end
        end

        context "When specified movie has no director" do
            it "should redirect to the movies page" do
                @movie_id = "1234"
                @movie = double('fake_movie').as_null_object

                expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)

                get :find_director, :id => @movie_id
                expect(response).to redirect_to(movies_path)
            end
        end
  end
end