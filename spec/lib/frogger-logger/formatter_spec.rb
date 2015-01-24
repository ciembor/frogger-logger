require 'spec_helper'

describe FroggerLogger::Formatter do
  context 'json format' do
    let(:formatter) { described_class.new(true) }

    describe '#format' do
      let(:content) { double }

      it 'should return content.to_json' do
        content.stub(:to_json) { 'json format' }
        expect(formatter.format(content)).to eq 'json format'
      end
    end

    describe '#to_json?' do
      it 'should return false if object is a string' do
        expect(formatter.to_json?('some string')).to be_false
      end

      it 'should return true if object respond to to_json and is not a string' do
        content = double
        content.stub(:to_json)
        expect(formatter.to_json?(content)).to be_true
      end
    end
  end

  context 'raw format' do
    let(:formatter) { described_class.new(false) }

    describe '#format' do
      it 'should return content' do
        content = "content"
        expect(formatter.format(content)).to eq content
      end
    end

    describe '#to_json?' do
      it 'should return false even if object respond to to_json and is not a string' do
        content = double
        content.stub(:to_json)
        expect(formatter.to_json?(content)).to be_false
      end
    end
  end
end