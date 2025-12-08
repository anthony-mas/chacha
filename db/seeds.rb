# =============================================================================
# ChaCha Demo Seeds
# =============================================================================
# This file creates demo data for showcasing the app.
# Safe to run multiple times (idempotent using find_or_create_by!).
# =============================================================================

puts "=" * 60
puts "ChaCha Demo Seeds"
puts "=" * 60

# -----------------------------------------------------------------------------
# 1. Categories
# -----------------------------------------------------------------------------
puts "\n[1/6] Creating categories..."

CATEGORIES = ["Art & Culture", "Sport", "Social", "Networking", "Hobbies"]

CATEGORIES.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end

puts "  -> #{Category.count} categories ready"

# -----------------------------------------------------------------------------
# 2. Users
# -----------------------------------------------------------------------------
puts "\n[2/6] Creating users..."

# Helper to create users safely
def seed_user(email:, name:, password: "password123")
  User.find_or_create_by!(email: email) do |u|
    u.name = name
    u.password = password
    u.password_confirmation = password
  end
end

# Host user (main demo account)
host = seed_user(
  email: "host@chacha.demo",
  name: "Alex Demo"
)

# Regular users
users = [
  seed_user(email: "marie@chacha.demo", name: "Marie Dupont"),
  seed_user(email: "jean@chacha.demo", name: "Jean Martin"),
  seed_user(email: "sophie@chacha.demo", name: "Sophie Bernard"),
  seed_user(email: "lucas@chacha.demo", name: "Lucas Petit"),
  seed_user(email: "emma@chacha.demo", name: "Emma Garcia"),
  seed_user(email: "thomas@chacha.demo", name: "Thomas Leroy")
]

puts "  -> #{User.count} users ready (host: #{host.email})"

# -----------------------------------------------------------------------------
# 3. Helper: Attach hero image from library
# -----------------------------------------------------------------------------
def attach_hero_image(event, filename)
  path = Rails.root.join("app/assets/images/hero_library", filename)
  return unless File.exist?(path)

  # Infer content type from extension for correctness
  content_type = case File.extname(filename).downcase
                 when '.png' then 'image/png'
                 when '.jpg', '.jpeg' then 'image/jpeg'
                 else 'application/octet-stream'
                 end

  # Skip if already attached with same filename
  return if event.hero_image.attached? && event.hero_image.filename.to_s == filename

  event.hero_image.purge if event.hero_image.attached?
  event.hero_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: content_type
  )
end

# -----------------------------------------------------------------------------
# 4. Events
# -----------------------------------------------------------------------------
puts "\n[3/6] Creating events..."

# Get categories for assignment
social_cat = Category.find_by(name: "Social")
sport_cat = Category.find_by(name: "Sport")
art_cat = Category.find_by(name: "Art & Culture")
networking_cat = Category.find_by(name: "Networking")
hobbies_cat = Category.find_by(name: "Hobbies")

events_data = [
  {
    title: "Rooftop Sunset Drinks",
    description: "Join us for an amazing sunset viewing party on one of Paris's best rooftops! Great drinks, good vibes, and incredible views of the city. Bring your friends!",
    location: "Le Perchoir, Paris",
    starts_on: 3.days.from_now.change(hour: 18, min: 30),
    ends_on: 3.days.from_now.change(hour: 22, min: 0),
    event_private: false,
    hero_image: "hero_1.jpg", # FIX: Changed from .png to .jpg
    category: social_cat
  },
  {
    title: "Saturday Morning Run",
    description: "Easy 5K run along the Seine! All levels welcome. We'll meet at the fountain and start at 9am sharp. Coffee afterwards!",
    location: "Jardins du Trocadero, Paris",
    starts_on: 5.days.from_now.change(hour: 9, min: 0),
    ends_on: 5.days.from_now.change(hour: 11, min: 0),
    event_private: false,
    hero_image: "hero_2.jpg", # FIX: Changed from .png to .jpg
    category: sport_cat
  },
  {
    title: "Wine & Canvas Night",
    description: "No experience needed! Come paint, sip wine, and have fun. All supplies provided. We'll be painting a Parisian street scene.",
    location: "Artisan Studio, Le Marais, Paris",
    starts_on: 7.days.from_now.change(hour: 19, min: 0),
    ends_on: 7.days.from_now.change(hour: 22, min: 0),
    event_private: false,
    hero_image: "hero_3.jpg", # FIX: Changed from .png to .jpg
    category: art_cat
  },
  {
    title: "Tech Founders Meetup",
    description: "Monthly gathering for startup founders and tech enthusiasts. Share ideas, find co-founders, or just network with like-minded people.",
    location: "Station F, Paris",
    starts_on: 10.days.from_now.change(hour: 18, min: 0),
    ends_on: 10.days.from_now.change(hour: 21, min: 0),
    event_private: false,
    hero_image: "hero_4.jpg", # FIX: Changed from .png to .jpg
    category: networking_cat
  },
  {
    title: "Board Game Sunday",
    description: "Catan, Ticket to Ride, Codenames... you name it! Bring your favorite games or try something new. Snacks provided.",
    location: "Cafe Oz, Chatelet, Paris",
    starts_on: 12.days.from_now.change(hour: 14, min: 0),
    ends_on: 12.days.from_now.change(hour: 18, min: 0),
    event_private: false,
    hero_image: "hero_5.jpg", # FIX: Changed from .png to .jpg (using hero_5 for unique image)
    category: hobbies_cat
  },
  {
    title: "Private Birthday Dinner",
    description: "Celebrating Sophie's 30th! Intimate dinner with close friends only. Restaurant is booked for 8pm.",
    location: "Le Petit Cler, Paris",
    starts_on: 14.days.from_now.change(hour: 20, min: 0),
    ends_on: 14.days.from_now.change(hour: 23, min: 30),
    event_private: true,
    hero_image: "hero_8.jpg", # FIX: Changed from .png to .jpg (using hero_8 for unique image)
    category: social_cat
  }
]

created_events = []

events_data.each do |event_data|
  hero_file = event_data.delete(:hero_image)
  category = event_data.delete(:category)

  event = Event.find_or_create_by!(
    title: event_data[:title],
    user: host
  ) do |e|
    e.assign_attributes(event_data)
  end

  # Attach hero image
  attach_hero_image(event, hero_file) if hero_file

  # Assign category
  if category && !event.categories.include?(category)
    event.categories << category
  end

  created_events << event
end

puts "  -> #{Event.count} events ready"

# -----------------------------------------------------------------------------
# 5. Participations
# -----------------------------------------------------------------------------
puts "\n[4/6] Creating participations..."

participation_count = 0

created_events.each_with_index do |event, idx|
  # Different participation patterns for each event
  case idx
  when 0 # Rooftop - very popular
    Participation.find_or_create_by!(event: event, user: users[0]) { |p| p.status = "going"; p.extra_guests = 1 }
    Participation.find_or_create_by!(event: event, user: users[1]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[2]) { |p| p.status = "going"; p.extra_guests = 2 }
    Participation.find_or_create_by!(event: event, user: users[3]) { |p| p.status = "maybe"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[4]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[5]) { |p| p.status = "not_going"; p.extra_guests = 0 }
  when 1 # Run - medium attendance
    Participation.find_or_create_by!(event: event, user: users[0]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[2]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[4]) { |p| p.status = "maybe"; p.extra_guests = 0 }
  when 2 # Wine & Canvas - good turnout
    Participation.find_or_create_by!(event: event, user: users[1]) { |p| p.status = "going"; p.extra_guests = 1 }
    Participation.find_or_create_by!(event: event, user: users[2]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[3]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[5]) { |p| p.status = "maybe"; p.extra_guests = 0 }
  when 3 # Tech meetup
    Participation.find_or_create_by!(event: event, user: users[0]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[3]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[5]) { |p| p.status = "going"; p.extra_guests = 1 }
  when 4 # Board games
    Participation.find_or_create_by!(event: event, user: users[1]) { |p| p.status = "going"; p.extra_guests = 0 }
    Participation.find_or_create_by!(event: event, user: users[4]) { |p| p.status = "going"; p.extra_guests = 2 }
    Participation.find_or_create_by!(event: event, user: users[5]) { |p| p.status = "maybe"; p.extra_guests = 0 }
  when 5 # Private birthday
    Participation.find_or_create_by!(event: event, user: users[2]) { |p| p.status = "going"; p.extra_guests = 0 } # Sophie!
    Participation.find_or_create_by!(event: event, user: users[0]) { |p| p.status = "going"; p.extra_guests = 1 }
    Participation.find_or_create_by!(event: event, user: users[1]) { |p| p.status = "going"; p.extra_guests = 0 }
  end
end

puts "  -> #{Participation.count} participations ready"

# -----------------------------------------------------------------------------
# 6. Posts (Activity Wall)
# -----------------------------------------------------------------------------
puts "\n[5/6] Creating posts..."

posts_data = [
  # Rooftop event posts
  { event_idx: 0, user_idx: 0, content: "Can't wait for this! The view is going to be amazing." },
  { event_idx: 0, user_idx: 2, content: "Should we bring anything? Happy to contribute some snacks!" },
  { event_idx: 0, user_idx: nil, content: "Hey everyone! Just confirmed the reservation. See you all there!" },

  # Run event posts
  { event_idx: 1, user_idx: nil, content: "Weather forecast looks perfect for Saturday! Let's do this." },
  { event_idx: 1, user_idx: 0, content: "I'll bring my running group - we're excited!" },

  # Wine & Canvas posts
  { event_idx: 2, user_idx: 1, content: "First time painting, a bit nervous but excited!" },
  { event_idx: 2, user_idx: nil, content: "Don't worry, it's super beginner-friendly. The instructor is great!" },
  { event_idx: 2, user_idx: 3, content: "What should we wear? Will it get messy?" },

  # Tech meetup posts
  { event_idx: 3, user_idx: nil, content: "This month's theme: AI tools for startups. Bring your questions!" },
  { event_idx: 3, user_idx: 3, content: "Looking forward to meeting other founders. Anyone working on fintech?" },
  { event_idx: 3, user_idx: 5, content: "I'll be there! Working on a developer tools startup." },

  # Board games posts
  { event_idx: 4, user_idx: 1, content: "I'm bringing Wingspan and Azul!" },
  { event_idx: 4, user_idx: 4, content: "Yes! Love Wingspan. Also bringing Codenames for larger groups." },

  # Private birthday posts
  { event_idx: 5, user_idx: nil, content: "Remember: it's a surprise! Don't spoil it!" },
  { event_idx: 5, user_idx: 0, content: "My lips are sealed! Already got a gift." }
]

created_posts = []

posts_data.each do |post_data|
  event = created_events[post_data[:event_idx]]
  author = post_data[:user_idx].nil? ? host : users[post_data[:user_idx]]

  post = Post.find_or_create_by!(
    event: event,
    user: author,
    content: post_data[:content]
  )
  created_posts << post
end

puts "  -> #{Post.count} posts ready"

# -----------------------------------------------------------------------------
# 7. Comments (Replies to posts)
# -----------------------------------------------------------------------------
puts "\n[6/6] Creating comments and reactions..."

comments_data = [
  { post_idx: 1, user_idx: nil, content: "Snacks would be great! Maybe some cheese?" },
  { post_idx: 1, user_idx: 4, content: "I can bring wine!" },
  { post_idx: 4, user_idx: 2, content: "Which running group? I might know some people!" },
  { post_idx: 5, user_idx: 3, content: "Same here! Let's be nervous together." },
  { post_idx: 7, user_idx: nil, content: "Aprons are provided, but avoid white just in case!" },
  { post_idx: 9, user_idx: 5, content: "Not fintech, but happy to chat about fundraising!" },
  { post_idx: 11, user_idx: nil, content: "Perfect! We'll have a great selection then." }
]

comments_data.each do |comment_data|
  post = created_posts[comment_data[:post_idx]]
  author = comment_data[:user_idx].nil? ? host : users[comment_data[:user_idx]]

  Comment.find_or_create_by!(
    post: post,
    user: author,
    content: comment_data[:content]
  )
end

puts "  -> #{Comment.count} comments ready"

# -----------------------------------------------------------------------------
# 8. Reactions (Likes on posts)
# -----------------------------------------------------------------------------
reactions_data = [
  { post_idx: 0, user_idxs: [1, 2, 4] },      # 3 likes on first rooftop post
  { post_idx: 2, user_idxs: [0, 2, 3, 4] },   # 4 likes on host's rooftop post
  { post_idx: 3, user_idxs: [0, 2] },         # 2 likes on run weather post
  { post_idx: 6, user_idxs: [1, 3] },         # 2 likes on beginner-friendly post
  { post_idx: 8, user_idxs: [3, 5] },         # 2 likes on AI theme post
  { post_idx: 11, user_idxs: [4, nil] },      # 2 likes on Wingspan post (nil = host)
  { post_idx: 13, user_idxs: [0, 1] }         # 2 likes on surprise reminder
]

reactions_data.each do |reaction_data|
  post = created_posts[reaction_data[:post_idx]]

  reaction_data[:user_idxs].each do |user_idx|
    reactor = user_idx.nil? ? host : users[user_idx]
    Reaction.find_or_create_by!(post: post, user: reactor)
  end
end

puts "  -> #{Reaction.count} reactions ready"

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
puts "\n" + "=" * 60
puts "SEED COMPLETE!"
puts "=" * 60
puts "\nDemo account credentials:"
puts "  Email:    host@chacha.demo"
puts "  Password: password123"
puts "\nData created:"
puts "  - #{User.count} users (1 host + #{User.count - 1} guests)"
puts "  - #{Event.count} events (#{Event.where(event_private: false).count} public, #{Event.where(event_private: true).count} private)"
puts "  - #{Participation.count} participations"
puts "  - #{Post.count} posts"
puts "  - #{Comment.count} comments"
puts "  - #{Reaction.count} reactions"
puts "  - #{Category.count} categories"
puts "=" * 60
