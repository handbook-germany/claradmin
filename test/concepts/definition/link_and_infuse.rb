# frozen_string_literal: true
require_relative '../../test_helper'
class LinkAndInfuseTest < ActiveSupport::TestCase
  let(:operation) { Definition::LinkAndInfuse }

  describe 'methods' do
    describe '#keys' do
      it 'returns an array from a comma separated value' do
        definition.key = 'a, foo,b , bar'
        definition.keys.must_equal %w(a foo b bar)
      end

      it 'returns a single key in an array' do
        definition.keys.must_equal ['foo']
      end
    end

    describe '::infuse' do
      it 'should put definition markup around the first found definition key' do
        FactoryGirl.create :definition, key: 'little', explanation: 'small'

        string = 'Little Mary had a little lamb.'

        Definition.infuse(string).must_equal(
          "<dfn class='JS-tooltip' data-id='1'>Little</dfn> Mary had a little"\
          ' lamb.'
        )
      end

      it 'should be case insensitive' do
        FactoryGirl.create :definition, key: 'Sexual Identity'

        string = 'My sexual identity is great.'

        Definition.infuse(string).must_equal(
          "My <dfn class='JS-tooltip' data-id='1'>sexual identity</dfn>"\
          ' is great.'
        )
      end

      it 'should only ever use the first definition key occurence when'\
         ' mutliple comma seperated keys are given' do
        FactoryGirl.create :definition, key: 'big', explanation: 'huge'
        FactoryGirl.create :definition, key: 'lethargic, lazy, apathetic'

        string = 'The big brown fox jumps over the apathetic, lazy dog.'

        Definition.infuse(string).must_equal(
          "The <dfn class='JS-tooltip' data-id='1'>big</dfn> brown fox jumps"\
          " over the <dfn class='JS-tooltip' data-id='2'>apathetic</dfn>, lazy"\
          ' dog.'
        )
      end

      it 'should find plural words although singular words are included and '\
         'first in key list' do
        FactoryGirl.create :definition, key: 'Weisung, Weisungen',
                                        explanation: 'Eine Weisung ist...'

        string = 'Die Weisungen'

        Definition.infuse(string).must_equal(
          "Die <dfn class='JS-tooltip' data-id='1'>Weisungen</dfn>"
        )
      end
    end
  end
end