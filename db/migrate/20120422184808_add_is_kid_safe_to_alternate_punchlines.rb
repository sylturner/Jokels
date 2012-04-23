class AddIsKidSafeToAlternatePunchlines < ActiveRecord::Migration
  def self.up
    add_column :alternate_punchlines, :is_kid_safe, :boolean

    AlternatePunchline.all.each do |alt_punch|
      alt_punch.is_kid_safe = !(ProfanityFilter::Base.profane?(alt_punch.punchline))
      alt_punch.save();
    end
  end

  def self.down
    remove_column :alternate_punchlines, :is_kid_safe
  end
end
