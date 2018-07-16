require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name     = extract_name
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action']     = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body
      set_default_headers
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding).content
    end

    def params
      @request.env['action_params'].each { |param| @request.params.merge!(param) }
    end

    def plain(text)
      resp(View::PlainRenderer.new(text))
    end

    def html(context)
      resp(View::HTMLRenderer.new(context, binding))
    end

    def resp(obj)
      @response.write(obj.content)
      @response['Content-Type'] = obj.header
    end

    def status(status)
      @response.status = status
    end

    def headers
      @response.headers
    end

    def action_params
      @request.env['action_params']
    end

    def render(template)
      return plain(template[:plain]) unless template[:plain].nil?
      return html(template[:html]) unless template[:html].nil?
      @request.env['simpler.template'] = template
    end

  end
end
