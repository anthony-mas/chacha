# frozen_string_literal: true

module AvatarHelper
  # Compute initials from user's name or email
  # - If name has 2+ words: first letter of first + first letter of last
  # - If name is single word: first 2 letters
  # - If no name: first 2 letters of email username
  def avatar_initials_for(user)
    if user.name.present?
      parts = user.name.strip.split
      if parts.length >= 2
        "#{parts.first[0]}#{parts.last[0]}".upcase
      else
        parts.first[0..1].upcase
      end
    else
      user.email.split("@").first[0..1].upcase
    end
  end

  # Generate a deterministic pastel color for a user
  # Uses HSL with fixed saturation (60%) and lightness (72%)
  # Hue is derived from a hash of the user's email for consistency
  def avatar_color_for(user)
    # Use email as the stable identifier for color generation
    hash_value = Digest::MD5.hexdigest(user.email.to_s.downcase)

    # Convert first 8 hex chars to integer, then map to hue (0-359)
    hue = hash_value[0..7].to_i(16) % 360

    # Fixed saturation and lightness for pastel colors
    saturation = 60
    lightness = 72

    hsl_to_hex(hue, saturation, lightness)
  end

  private

  # Convert HSL values to hex color string
  # h: 0-360, s: 0-100, l: 0-100
  def hsl_to_hex(h, s, l)
    s /= 100.0
    l /= 100.0

    c = (1 - (2 * l - 1).abs) * s
    x = c * (1 - ((h / 60.0) % 2 - 1).abs)
    m = l - c / 2

    r, g, b = case h
              when 0...60 then [c, x, 0]
              when 60...120 then [x, c, 0]
              when 120...180 then [0, c, x]
              when 180...240 then [0, x, c]
              when 240...300 then [x, 0, c]
              else [c, 0, x]
              end

    # Convert to 0-255 range and format as hex
    r = ((r + m) * 255).round
    g = ((g + m) * 255).round
    b = ((b + m) * 255).round

    format("#%02X%02X%02X", r, g, b)
  end
end
