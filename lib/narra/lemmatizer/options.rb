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

    # generator default options
    OPTIONS = {
        default_language: 'en',
        force_to_use_default_language: false,
        meta_fields_to_analyze: 'text',
        cs_default_pos_tags_inclusion: 'AA, NN, VB, Vp',
        cs_default_words_exclusion: 'být',
        en_default_pos_tags_inclusion: 'AA, NN, VB, Vp',
        en_default_words_exclusion: 'be, the, in',
        h_point_usage: true,
        h_point_ratio: 5,
        keywords_limit: 20
    }
  end
end