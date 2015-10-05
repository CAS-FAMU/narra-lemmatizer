#
# Copyright (C) 2015 CAS / FAMU
#
# This file is part of Narra Core.
#
# Narra Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@marigan.net>
#

require 'narra/spi'
require 'narra/tools'

require 'narra/lemmatizer/options'

require 'narra/lemmatizer/extensions/hpoint'
require 'narra/lemmatizer/extensions/morphodita'
require 'narra/lemmatizer/extensions/parser'

module Narra
  module Lemmatizer
    class Generator < Narra::SPI::Generator

      include Narra::Lemmatizer::Extensions::Morphodita
      include Narra::Lemmatizer::Extensions::Parser
      include Narra::Lemmatizer::Extensions::Hpoint

      # Default values
      @identifier = :lemmatizer
      @title = 'Keywords from Lemma frequency'
      @description = 'NARRA Generator using lemmatizer to generate most frequent keywords'
      @options = Narra::Lemmatizer::OPTIONS

      def self.valid?(item_to_check, options = {})
        # get fields to analyze
        fields = Generator.to_array(Generator.parse_options(:meta_fields_to_analyze, options))
        # parse them and check if there is such fields
        result = fields.select { |field| !Narra::Extensions::Meta.get_meta(item_to_check, name: field).nil? }
        # check if it is empty
        !result.empty?
      end

      def initialization
        # initialization of the default settings
        Narra::Tools::Settings.defaults[:morphodita_analyzer_binary] = '/opt/morphodita/src/run_morpho_analyze'
        Narra::Tools::Settings.defaults[:morphodita_analyzer_params] = '--from_tagger --input=untokenized --convert_tagset=strip_lemma_comment --output=xml'
        Narra::Tools::Settings.defaults[:morphodita_cs_model] = '/opt/czech-morfflex-pdt-131112/czech-morfflex-pdt-131112-pos_only.tagger'
        Narra::Tools::Settings.defaults[:morphodita_en_model] = '/opt/english-morphium-wsj-140407/english-morphium-wsj-140407.tagger'
      end

      def generate(options = {})
        # create temporary text file to use
        text = Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_text'
        # get fields to analyze
        fields = Generator.to_array(Generator.parse_options(:meta_fields_to_analyze, options))

        # write content of fields into it
        File.open(text, 'w') { |file|
          fields.each do |field|
            file.write(get_meta(name: field)[:value])
          end
        }

        # resolve language from the item
        language = get_meta(name: 'language')
        # check
        language = (language.nil? ? Generator.parse_options(:default_language, options) : language[:value]).to_sym

        # run morphodita analyzer
        raw_xml = run_morphodita_analyzer(language, text)

        # prepare lemmas array
        lemmas = parse_morphodita_output(raw_xml)

        # calculate frequency
        frequency = lemmas.each_with_object(Hash.new(0)) { |item, counts| counts[item] += 1 }.sort { |x, y| x[1] <=> y[1] }.reverse

        # inclusion tags
        inclusion = Generator.to_array(language.equal?(:cs) ?
            Generator.parse_options(:cs_default_pos_tags_inclusion, options) : Generator.parse_options(:en_default_pos_tags_inclusion, options))
        # exclusion words
        exclusion = Generator.to_array(language.equal?(:cs) ?
            Generator.parse_options(:cs_default_words_exclusion, options) : Generator.parse_options(:en_default_words_exclusion, options))

        # inclusion filter
        after_inclusion = inclusion.empty? ? frequency : frequency.select { |item| !(item[0][:tag] =~ /\A#{"^[#{inclusion.join('|')}]{2}"}/).nil? }
        # exlusion filter
        after_exclusion = exclusion.empty? ? after_inclusion : after_inclusion.select { |item| !exclusion.include?(item[0][:value].downcase) }
        # keywords limit
        limitation = Generator.parse_options(:keywords_limit, options).to_i

        # check is using h-point
        if Generator.parse_options(:h_point_usage, options)
          # hpoint ratio
          ratio = Generator.parse_options(:h_point_ratio, options).to_i
          # resolve
          keywords = h_point(after_exclusion, ratio).collect { |item| item[0][:value] }.first(limitation)
        else
          keywords = after_exclusion.collect { |item| item[0][:value] }.first(limitation)
        end

        # add meta keywords
        add_meta(name: 'keywords', value: keywords.join(', '))
      end
    end
  end
end