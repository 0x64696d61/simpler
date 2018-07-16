module Simpler
  class View
    class PlainRenderer

      attr_reader :content, :header

      def initialize(text)
        @content = text
        @header  = 'text/plain'
      end

    end
  end
end