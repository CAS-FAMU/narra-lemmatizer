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

require 'nokogiri'

module Narra
  module Lemmatizer
    module Extensions
      module Parser

        # parse morphodita xml output via nokogiri
        def parse_morphodita_output(xml)
          # parse xml output
          document = Nokogiri::XML("<sentences>#{xml}</sentences>")
          # prepare lemmas array
          lemmas = []
          # parse lemmas
          document.xpath('//token').each do |node|
            # collect whole analysis and calculate frequency
            analysis = node.xpath('analysis').collect { |item|
              {
                  value: item.attribute('lemma').value.split('-').first,
                  tag: item.attribute('tag').value
              } }.each_with_object(Hash.new(0)) { |item, counts| counts[item] += 1 }.sort { |x, y| x[1] <=> y[1] }

            # fine resolution
            if analysis.collect { |item| item[1] }.uniq.count == 1 &&
                (analysis.count > 2 || analysis.select { |item| item[0][:tag].start_with?('NN') }.count == 1)
              analysis = analysis.first[0]
            else
              analysis = analysis.reverse.first[0]
            end

            # add into lemmas
            lemmas << analysis if !analysis[:value].nil? && analysis[:value].size > 1
          end
          # return analyzed lemmas
          return lemmas
        end
      end
    end
  end
end