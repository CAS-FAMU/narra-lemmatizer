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

module Narra
  module Lemmatizer
    module Extensions
      module Morphodita

        # runs external morphodita analyzer
        def run_morphodita_analyzer(language, text)
          # prepare morphodita command
          morph_exec = Narra::Tools::Settings.morphodita_analyzer_binary
          morph_params = Narra::Tools::Settings.morphodita_analyzer_params
          morph_model = Narra::Tools::Settings.get("morphodita_#{language.to_s}_model")
          # run analyzer
          return `#{morph_exec} #{morph_params} #{morph_model} 1 #{text}`
        end
      end
    end
  end
end