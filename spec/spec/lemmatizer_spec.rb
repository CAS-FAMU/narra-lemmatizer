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

require 'spec_helper'

describe Narra::Lemmatizer::Generator do
  before(:each) do
    # create metadata
    @meta= FactoryGirl.create(:meta_item, :source, name: 'text')

    # create items
    @item_meta = FactoryGirl.create(:item, meta: [@meta])
    @item = FactoryGirl.create(:item, meta: [])

    # create event
    @event = FactoryGirl.create(:event, item: @item_meta)
  end

  it 'can be instantiated' do
    expect(Narra::Lemmatizer::Generator.new(@item_meta, @event)).to be_an_instance_of(Narra::Lemmatizer::Generator)
  end

  it 'should be properly registered' do
    expect(Narra::Core.generators).to include(Narra::Lemmatizer::Generator)
  end

  it 'should validate items' do
    expect(Narra::Lemmatizer::Generator.valid?(@item_meta)).to match(true)
    expect(Narra::Lemmatizer::Generator.valid?(@item)).to match(false)
  end
end