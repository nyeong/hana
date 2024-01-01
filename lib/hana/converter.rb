require 'asciidoctor'
module Hana
  class Converter < (Asciidoctor::Converter.for 'html5')
    register_for 'html5'

    def convert_inline_anchor(node)
      case node.type

      when :xref
        # remove .html for inter-doc xref
        if (path = node.attributes['path'])
          attrs = (append_link_constraint_attrs node, node.role ? [%( class="#{node.role}")] : []).join
          target = path.gsub(/\.html$/, '')
          text = node.text || path
          %(<a href="/#{target}"#{attrs}>#{text}</a>)
        else
          super node
        end
      else
        super node
      end
    end
  end
end
