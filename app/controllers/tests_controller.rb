class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status(201)
    render html: '<h1><%= @time %></h1>'
  end

  def create
  end

  def show
    render plain: 'just test'

    params
  end

end
