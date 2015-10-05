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

require 'narra/tools'

module Narra
  module Lemmatizer
    module Extensions
      module Settings

        def self.extended(obj)
          obj.instance_exec {
            # initialization of the default settings
            Narra::Tools::Settings.defaults[:morphodita_analyzer_binary] = '/opt/morphodita/src/run_morpho_analyze'
            Narra::Tools::Settings.defaults[:morphodita_analyzer_params] = '--from_tagger --input=untokenized --convert_tagset=strip_lemma_comment --output=xml'
            Narra::Tools::Settings.defaults[:morphodita_cs_model] = '/opt/czech-morfflex-pdt-131112/czech-morfflex-pdt-131112-pos_only.tagger'
            Narra::Tools::Settings.defaults[:morphodita_en_model] = '/opt/english-morphium-wsj-140407/english-morphium-wsj-140407.tagger'
          }
        end
      end
    end
  end
end