# frozen_string_literal: true

require_relative './spec_helper'
require_relative '../lib/hana/lint'

describe Hana::Lint do
  describe 'replace_interdoc_xrefs' do
    titles = {
      'index' => '인덱스',
      'hanassig' => '하나씩'
    }

    it 'adds title' do
      line = '- <<index#>>'
      to_be = '- <<index#,인덱스>>'
      expect(Hana::Lint.replace_interdoc_xrefs(line, titles)).to eq(to_be)
    end

    it 'updates title into new one' do
      line = '- <<index#,옛날 타이틀>>'
      to_be = '- <<index#,인덱스>>'
      expect(Hana::Lint.replace_interdoc_xrefs(line, titles)).to eq(to_be)
    end

    it 'updates multiple xrefs' do
      line = '<<index#>> and <<hanassig#>>'
      to_be = '<<index#,인덱스>> and <<hanassig#,하나씩>>'
      expect(Hana::Lint.replace_interdoc_xrefs(line, titles)).to eq(to_be)
    end

    it 'should not update non-interdoc xref' do
      line = '- <<index>>'
      expect(Hana::Lint.replace_interdoc_xrefs(line, titles)).to eq(line)
    end

    it 'should update multiple lines' do
      source = <<~ASCII
        - <<index#>>
        - <<hanassig#>>
        안녕!
      ASCII
      to_be = <<~ASCII
        - <<index#,인덱스>>
        - <<hanassig#,하나씩>>
        안녕!
      ASCII
      expect(Hana::Lint.replace_interdoc_xrefs(source, titles)).to eq(to_be)
    end

    it 'should not update in code inline' do
      source1 = '`<<index#>>`'
      source2 = '`+<<index#>>+`'
      expect(Hana::Lint.replace_interdoc_xrefs(source1, titles)).to eq(source1)
      expect(Hana::Lint.replace_interdoc_xrefs(source2, titles)).to eq(source2)
    end

    it 'should not update in code block' do
      source = <<~ASCII
        ----
        <<index#>>
        ----
      ASCII
      expect(Hana::Lint.replace_interdoc_xrefs(source, titles)).to eq(source)
    end
  end
end
