require 'erb'

module Simpler
  class View
    class HTMLRenderer

      attr_reader :content, :header

      def initialize(html, binding)
        @content = html
        @binding = binding
        @header  = 'text/html'
        render
      end

      def render
        @content = ERB.new(@content).result(@binding)
      end

    end
  end
end