# frozen_string_literal: true

ActiveAdmin.register Product do
  permit_params :name, :price, :image

  filter :name

  form do |f|
    inputs 'Details' do
      f.input :name
      f.input :price, input_html: { min: 0.01 }
      f.input :image, as: :file
      f.actions
    end
  end

  show do
    attributes_table do
      rows :name, :price, :created_at, :updated_at
      row :image do |product|
        image_tag product.image_url
      end
    end
  end
end
