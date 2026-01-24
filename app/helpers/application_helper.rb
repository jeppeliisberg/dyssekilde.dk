module ApplicationHelper
  def meta_title
    return current_page.seo_title if current_page.seo_title.present?
    "#{current_page.title} | #{current_spina_account.name}"
  end

  def meta_description
    return current_page.description if current_page.description.present?

    text = extract_page_text
    return nil if text.blank?

    truncate(strip_tags(text), length: 162, separator: " ", omission: "...")
  end

  def og_image_url
    image = find_og_image
    return nil unless image

    current_page.content.image_url(image, resize_to_fill: [ 1200, 630 ])
  end

  private

  def extract_page_text
    [ :text, :house_description ].each do |part_name|
      text = current_page.content(part_name)
      return text if text.present?
    end
    nil
  end

  def find_og_image
    # Check single image parts first
    [ :hero_image, :og_image ].each do |part_name|
      image = current_page.content(part_name)
      return image if image.present?
    end

    # Check image collections - take first image
    [ :gallery_images, :house_images ].each do |part_name|
      part = current_page.find_part(part_name)
      if part&.images&.any?
        return part.images.first
      end
    end

    nil
  end
end
