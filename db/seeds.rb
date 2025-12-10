# =============================================================================
# ChaCha Demo Seeds
# =============================================================================
# Demo scenario for Charlotte's live demo.
# Run: rails db:drop db:create db:migrate db:seed
# =============================================================================

require 'fileutils' # Ensure FileUtils is required for clearing local storage in dev/test

puts "=" * 60
puts "ChaCha Demo Seeds"
puts "=" * 60

# -----------------------------------------------------------------------------
# Active Storage Configuration Check (The fix is that we rely on config/environments/X.rb)
# -----------------------------------------------------------------------------
# If you are seeding with images, Active Storage must be configured to use
# a PERSISTENT service (like Cloudinary on Heroku).
# We REMOVE the manual override to :local storage here, so the environment
# configuration (Cloudinary in Production) is used automatically.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 0. Clear existing data (in dependency order)
# -----------------------------------------------------------------------------
puts "\n[0/7] Clearing existing data..."

Reaction.destroy_all
Comment.destroy_all
Post.destroy_all
Participation.destroy_all
CategoryEvent.destroy_all if defined?(CategoryEvent)
Event.destroy_all
User.destroy_all
Category.destroy_all

# Clear associated files using Active Storage's method (works for Cloudinary and Disk)
ActiveStorage::Blob.all.each(&:purge_later)

# In development/test, we also clear the local storage folder for good measure.
if ActiveStorage::Blob.service.class.name.include?("DiskService")
  puts "[INFO] Clearing local disk storage folder."
  FileUtils.rm_rf(Rails.root.join("storage"))
  FileUtils.mkdir_p(Rails.root.join("storage"))
else
  # On Heroku (Cloudinary), this message confirms we are using cloud storage
  puts "[INFO] Using cloud storage for seeding hero images"
end

puts "  -> All tables and storage cleared"

# -----------------------------------------------------------------------------
# 1. Categories
# -----------------------------------------------------------------------------
puts "\n[1/7] Creating categories..."

CATEGORIES = ["Art & Culture", "Sport", "Social", "Networking", "Hobbies"]

categories = {}
CATEGORIES.each do |name|
  categories[name] = Category.create!(name: name)
end

puts "  -> #{Category.count} categories ready"

# -----------------------------------------------------------------------------
# 2. Users
# -----------------------------------------------------------------------------
puts "\n[2/7] Creating users..."

# Main demo user: Charlotte (she will host some events, but NOT attend others)
charlotte = User.create!(
  email: "charlotte@chacha.demo",
  name: "Charlotte",
  password: "password123",
  password_confirmation: "password123"
)

# Other users who will host events and participate
users = {
  marie: User.create!(email: "marie@chacha.demo", name: "Marie Dupont", password: "password123", password_confirmation: "password123"),
  jean: User.create!(email: "jean@chacha.demo", name: "Jean Martin", password: "password123", password_confirmation: "password123"),
  sophie: User.create!(email: "sophie@chacha.demo", name: "Sophie Bernard", password: "password123", password_confirmation: "password123"),
  lucas: User.create!(email: "lucas@chacha.demo", name: "Lucas Petit", password: "password123", password_confirmation: "password123"),
  emma: User.create!(email: "emma@chacha.demo", name: "Emma Garcia", password: "password123", password_confirmation: "password123"),
  thomas: User.create!(email: "thomas@chacha.demo", name: "Thomas Leroy", password: "password123", password_confirmation: "password123"),
  julie: User.create!(email: "julie@chacha.demo", name: "Julie Moreau", password: "password123", password_confirmation: "password123"),
  marc: User.create!(email: "marc@chacha.demo", name: "Marc Dubois", password: "password123", password_confirmation: "password123"),
  claire: User.create!(email: "claire@chacha.demo", name: "Claire Fontaine", password: "password123", password_confirmation: "password123"),
  pierre: User.create!(email: "pierre@chacha.demo", name: "Pierre Blanc", password: "password123", password_confirmation: "password123")
}

# Array of all non-Charlotte users for easy access
other_users = users.values

puts "  -> #{User.count} users ready (main demo user: #{charlotte.email})"

# -----------------------------------------------------------------------------
# 3. Helper: Attach hero image
# -----------------------------------------------------------------------------
def attach_hero_image(event, filename)
  path = Rails.root.join("app/assets/images/hero_library", filename)
  unless File.exist?(path)
    puts "    [WARN] Hero image not found: #{path}"
    return
  end

  content_type = case File.extname(filename).downcase
                 when '.png' then 'image/png'
                 when '.jpg', '.jpeg' then 'image/jpeg'
                 else 'application/octet-stream'
                 end

  event.hero_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: content_type
  )
end

# -----------------------------------------------------------------------------
# 4. Events (10 events total, Charlotte hosts 3, others host 7)
# -----------------------------------------------------------------------------
puts "\n[3/7] Creating events..."

events = {}

# ─────────────────────────────────────────────────────────────────────────────
# CHARLOTTE'S EVENTS (3 events she hosts - will appear in "My Events")
# ─────────────────────────────────────────────────────────────────────────────

# EVENT 1: hero_1 - Disco Balls (CHARLOTTE HOSTS)
events[:disco] = Event.create!(
  user: charlotte,
  title: "Rooftop Disco Night",
  description: "Get your groove on under the disco balls! Join us for an unforgettable night of 70s vibes, funky beats, and stunning rooftop views. Dress code: glitter and glamour!",
  location: "Le Perchoir, Paris",
  starts_on: 5.days.from_now.change(hour: 21, min: 0),
  ends_on: 6.days.from_now.change(hour: 2, min: 0),
  event_private: false
)
attach_hero_image(events[:disco], "hero_1.jpg")
events[:disco].categories << categories["Social"]

# EVENT 7: hero_7 - Champagne Celebration (CHARLOTTE HOSTS)
events[:champagne] = Event.create!(
  user: charlotte,
  title: "Champagne Sunset Celebration",
  description: "Pop the bubbly! Join us for an elegant champagne tasting to celebrate life's beautiful moments. Stunning views, fine bubbles, and great company.",
  location: "Peninsula Paris, Rooftop",
  starts_on: 14.days.from_now.change(hour: 18, min: 30),
  ends_on: 14.days.from_now.change(hour: 22, min: 0),
  event_private: false
)
attach_hero_image(events[:champagne], "hero_7.jpg")
events[:champagne].categories << categories["Networking"]

# EVENT 8: hero_8 - Birthday Cake (CHARLOTTE HOSTS - Private)
events[:birthday] = Event.create!(
  user: charlotte,
  title: "My Birthday Bash",
  description: "You're invited to celebrate my birthday! Cake, dancing, and surprises await. Can't wait to see you all there!",
  location: "Le Petit Palais, Paris",
  starts_on: 20.days.from_now.change(hour: 19, min: 0),
  ends_on: 20.days.from_now.change(hour: 23, min: 59),
  event_private: true
)
attach_hero_image(events[:birthday], "hero_8.jpg")
events[:birthday].categories << categories["Social"]

# ─────────────────────────────────────────────────────────────────────────────
# OTHER USERS' EVENTS (7 events - will appear in Charlotte's "Discover")
# Charlotte has NO participation in these events
# ─────────────────────────────────────────────────────────────────────────────

# EVENT 2: hero_2 - Sparkler / Allumette Bengale
events[:sparkler] = Event.create!(
  user: users[:marie],
  title: "New Year's Sparkler Night",
  description: "Ring in the new year with sparklers and champagne on the terrace! Bring your friends for this magical midnight celebration under the stars.",
  location: "Terrasse de l'Observatoire, Paris",
  starts_on: 3.days.from_now.change(hour: 22, min: 0),
  ends_on: 4.days.from_now.change(hour: 2, min: 0),
  event_private: false
)
attach_hero_image(events[:sparkler], "hero_2.jpg")
events[:sparkler].categories << categories["Social"]

# EVENT 3: hero_3 - Concert
events[:concert] = Event.create!(
  user: users[:jean],
  title: "Indie Rock Live at La Cigale",
  description: "Three amazing indie bands performing live! Get ready for an unforgettable night of music, craft beers, and incredible energy.",
  location: "La Cigale, Paris",
  starts_on: 7.days.from_now.change(hour: 20, min: 0),
  ends_on: 8.days.from_now.change(hour: 0, min: 30),
  event_private: false
)
attach_hero_image(events[:concert], "hero_3.jpg")
events[:concert].categories << categories["Art & Culture"]

# EVENT 4: hero_4 - Disco Vibe
events[:retro] = Event.create!(
  user: users[:sophie],
  title: "80s Retro Dance Party",
  description: "Neon lights, synth beats, and leg warmers! Come dance to the greatest hits of the 80s. Best costume wins a prize!",
  location: "Rex Club, Paris",
  starts_on: 10.days.from_now.change(hour: 23, min: 0),
  ends_on: 11.days.from_now.change(hour: 4, min: 0),
  event_private: false
)
attach_hero_image(events[:retro], "hero_4.jpg")
events[:retro].categories << categories["Social"]

# EVENT 5: hero_5 - Sport Game
events[:football] = Event.create!(
  user: users[:lucas],
  title: "Champions League Watch Party",
  description: "Big match on the giant screen! Bring your jersey and cheer with fellow fans. Pizza, wings, and drinks provided!",
  location: "O'Sullivan's Pub, Grands Boulevards, Paris",
  starts_on: 2.days.from_now.change(hour: 20, min: 45),
  ends_on: 2.days.from_now.change(hour: 23, min: 30),
  event_private: false
)
attach_hero_image(events[:football], "hero_5.jpg")
events[:football].categories << categories["Sport"]

# EVENT 6: hero_6 - Tennis Court
events[:tennis] = Event.create!(
  user: users[:emma],
  title: "Sunday Doubles Tournament",
  description: "Friendly tennis tournament for all levels! Partners will be randomly assigned. Refreshments and awards ceremony after the games.",
  location: "Tennis Club de Paris, Bois de Boulogne",
  starts_on: 8.days.from_now.change(hour: 10, min: 0),
  ends_on: 8.days.from_now.change(hour: 15, min: 0),
  event_private: false
)
attach_hero_image(events[:tennis], "hero_6.jpg")
events[:tennis].categories << categories["Sport"]

# EVENT 9: hero_9 - Gender Reveal
events[:gender_reveal] = Event.create!(
  user: users[:julie],
  title: "Baby Reveal Brunch",
  description: "Marie and Jean are revealing the baby's gender! Join us for brunch, games, and the big moment. Pink or blue? Come find out!",
  location: "Jardin des Tuileries, Paris",
  starts_on: 16.days.from_now.change(hour: 11, min: 0),
  ends_on: 16.days.from_now.change(hour: 14, min: 0),
  event_private: false
)
attach_hero_image(events[:gender_reveal], "hero_9.jpg")
events[:gender_reveal].categories << categories["Social"]

# EVENT 10: hero_10 - Halloween
events[:halloween] = Event.create!(
  user: users[:marc],
  title: "Halloween Costume Bash",
  description: "Spooky season is here! Best costume wins a prize. Haunted house corner, themed cocktails, and monster mash playlist all night.",
  location: "Wanderlust, Paris",
  starts_on: 25.days.from_now.change(hour: 21, min: 0),
  ends_on: 26.days.from_now.change(hour: 3, min: 0),
  event_private: false
)
attach_hero_image(events[:halloween], "hero_10.jpg")
events[:halloween].categories << categories["Social"]

puts "  -> #{Event.count} events ready"
puts "     Charlotte hosts: #{Event.where(user: charlotte).pluck(:title).join(', ')}"

# -----------------------------------------------------------------------------
# 5. Participations (Charlotte does NOT participate in events she doesn't host)
# -----------------------------------------------------------------------------
puts "\n[4/7] Creating participations..."

# ─────────────────────────────────────────────────────────────────────────────
# CHARLOTTE'S EVENTS - Other users RSVP to her events
# ─────────────────────────────────────────────────────────────────────────────

# Disco Night (Charlotte hosts) - 8 guests
Participation.create!(event: events[:disco], user: users[:marie], status: "going", extra_guests: 2)
Participation.create!(event: events[:disco], user: users[:jean], status: "going", extra_guests: 1)
Participation.create!(event: events[:disco], user: users[:sophie], status: "going", extra_guests: 0)
Participation.create!(event: events[:disco], user: users[:lucas], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:disco], user: users[:emma], status: "going", extra_guests: 1)
Participation.create!(event: events[:disco], user: users[:thomas], status: "going", extra_guests: 0)
Participation.create!(event: events[:disco], user: users[:julie], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:disco], user: users[:marc], status: "not_going", extra_guests: 0)

# Champagne Celebration (Charlotte hosts) - 7 guests
Participation.create!(event: events[:champagne], user: users[:marie], status: "going", extra_guests: 1)
Participation.create!(event: events[:champagne], user: users[:sophie], status: "going", extra_guests: 0)
Participation.create!(event: events[:champagne], user: users[:emma], status: "going", extra_guests: 2)
Participation.create!(event: events[:champagne], user: users[:julie], status: "going", extra_guests: 0)
Participation.create!(event: events[:champagne], user: users[:marc], status: "going", extra_guests: 0)
Participation.create!(event: events[:champagne], user: users[:claire], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:champagne], user: users[:pierre], status: "not_going", extra_guests: 0)

# Birthday Bash (Charlotte hosts, private) - 6 guests
Participation.create!(event: events[:birthday], user: users[:marie], status: "going", extra_guests: 0)
Participation.create!(event: events[:birthday], user: users[:jean], status: "going", extra_guests: 1)
Participation.create!(event: events[:birthday], user: users[:sophie], status: "going", extra_guests: 0)
Participation.create!(event: events[:birthday], user: users[:emma], status: "going", extra_guests: 0)
Participation.create!(event: events[:birthday], user: users[:thomas], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:birthday], user: users[:claire], status: "going", extra_guests: 2)

# ─────────────────────────────────────────────────────────────────────────────
# OTHER EVENTS - Charlotte does NOT participate (so they appear in Discover)
# ─────────────────────────────────────────────────────────────────────────────

# Sparkler Night (Marie hosts) - 7 guests, NO Charlotte
Participation.create!(event: events[:sparkler], user: users[:jean], status: "going", extra_guests: 1)
Participation.create!(event: events[:sparkler], user: users[:sophie], status: "going", extra_guests: 0)
Participation.create!(event: events[:sparkler], user: users[:lucas], status: "going", extra_guests: 2)
Participation.create!(event: events[:sparkler], user: users[:emma], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:sparkler], user: users[:thomas], status: "going", extra_guests: 0)
Participation.create!(event: events[:sparkler], user: users[:claire], status: "going", extra_guests: 1)
Participation.create!(event: events[:sparkler], user: users[:pierre], status: "not_going", extra_guests: 0)

# Concert (Jean hosts) - 8 guests, NO Charlotte
Participation.create!(event: events[:concert], user: users[:marie], status: "going", extra_guests: 1)
Participation.create!(event: events[:concert], user: users[:sophie], status: "going", extra_guests: 0)
Participation.create!(event: events[:concert], user: users[:lucas], status: "going", extra_guests: 2)
Participation.create!(event: events[:concert], user: users[:emma], status: "going", extra_guests: 0)
Participation.create!(event: events[:concert], user: users[:thomas], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:concert], user: users[:julie], status: "going", extra_guests: 0)
Participation.create!(event: events[:concert], user: users[:marc], status: "going", extra_guests: 1)
Participation.create!(event: events[:concert], user: users[:pierre], status: "not_going", extra_guests: 0)

# Retro Dance (Sophie hosts) - 6 guests, NO Charlotte
Participation.create!(event: events[:retro], user: users[:marie], status: "going", extra_guests: 1)
Participation.create!(event: events[:retro], user: users[:jean], status: "going", extra_guests: 0)
Participation.create!(event: events[:retro], user: users[:lucas], status: "going", extra_guests: 0)
Participation.create!(event: events[:retro], user: users[:emma], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:retro], user: users[:thomas], status: "going", extra_guests: 2)
Participation.create!(event: events[:retro], user: users[:claire], status: "not_going", extra_guests: 0)

# Football Watch (Lucas hosts) - 8 guests, NO Charlotte
Participation.create!(event: events[:football], user: users[:jean], status: "going", extra_guests: 1)
Participation.create!(event: events[:football], user: users[:thomas], status: "going", extra_guests: 0)
Participation.create!(event: events[:football], user: users[:marc], status: "going", extra_guests: 2)
Participation.create!(event: events[:football], user: users[:pierre], status: "going", extra_guests: 0)
Participation.create!(event: events[:football], user: users[:marie], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:football], user: users[:sophie], status: "not_going", extra_guests: 0)
Participation.create!(event: events[:football], user: users[:emma], status: "going", extra_guests: 1)
Participation.create!(event: events[:football], user: users[:julie], status: "maybe", extra_guests: 0)

# Tennis Tournament (Emma hosts) - 7 guests, NO Charlotte
Participation.create!(event: events[:tennis], user: users[:marie], status: "going", extra_guests: 0)
Participation.create!(event: events[:tennis], user: users[:jean], status: "going", extra_guests: 0)
Participation.create!(event: events[:tennis], user: users[:sophie], status: "going", extra_guests: 0)
Participation.create!(event: events[:tennis], user: users[:lucas], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:tennis], user: users[:thomas], status: "going", extra_guests: 1)
Participation.create!(event: events[:tennis], user: users[:julie], status: "going", extra_guests: 0)
Participation.create!(event: events[:tennis], user: users[:claire], status: "not_going", extra_guests: 0)

# Gender Reveal (Julie hosts) - 6 guests, NO Charlotte
Participation.create!(event: events[:gender_reveal], user: users[:marie], status: "going", extra_guests: 0)
Participation.create!(event: events[:gender_reveal], user: users[:jean], status: "going", extra_guests: 0)
Participation.create!(event: events[:gender_reveal], user: users[:sophie], status: "going", extra_guests: 1)
Participation.create!(event: events[:gender_reveal], user: users[:emma], status: "going", extra_guests: 0)
Participation.create!(event: events[:gender_reveal], user: users[:thomas], status: "going", extra_guests: 0)
Participation.create!(event: events[:gender_reveal], user: users[:claire], status: "maybe", extra_guests: 0)

# Halloween (Marc hosts) - 9 guests, NO Charlotte
Participation.create!(event: events[:halloween], user: users[:marie], status: "going", extra_guests: 0)
Participation.create!(event: events[:halloween], user: users[:jean], status: "going", extra_guests: 1)
Participation.create!(event: events[:halloween], user: users[:sophie], status: "going", extra_guests: 2)
Participation.create!(event: events[:halloween], user: users[:lucas], status: "maybe", extra_guests: 0)
Participation.create!(event: events[:halloween], user: users[:emma], status: "going", extra_guests: 0)
Participation.create!(event: events[:halloween], user: users[:thomas], status: "going", extra_guests: 1)
Participation.create!(event: events[:halloween], user: users[:julie], status: "going", extra_guests: 0)
Participation.create!(event: events[:halloween], user: users[:claire], status: "going", extra_guests: 0)
Participation.create!(event: events[:halloween], user: users[:pierre], status: "not_going", extra_guests: 0)

puts "  -> #{Participation.count} participations ready"
puts "     Charlotte's participations: #{charlotte.participations.count} (should be 0 for Discover to work)"

# -----------------------------------------------------------------------------
# 6. Posts (Activity Feed) - For 7 events with 2-4 posts each
# -----------------------------------------------------------------------------
puts "\n[5/7] Creating posts..."

posts = {}

# ─────────────────────────────────────────────────────────────────────────────
# DISCO posts (Charlotte's event - 4 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:disco_1] = Post.create!(event: events[:disco], user: charlotte, content: "Dress code reminder: glitter, sequins, and good vibes only! Who's ready to boogie?")
posts[:disco_2] = Post.create!(event: events[:disco], user: users[:marie], content: "I'm bringing my platform shoes! Can't wait!")
posts[:disco_3] = Post.create!(event: events[:disco], user: users[:sophie], content: "Any song requests? I know the DJ!")
posts[:disco_4] = Post.create!(event: events[:disco], user: charlotte, content: "Just confirmed the rooftop is ours until 2am. Let's make it count!")

# ─────────────────────────────────────────────────────────────────────────────
# CHAMPAGNE posts (Charlotte's event - 3 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:champagne_1] = Post.create!(event: events[:champagne], user: charlotte, content: "The sunset view is going to be stunning! Don't forget your cameras.")
posts[:champagne_2] = Post.create!(event: events[:champagne], user: users[:sophie], content: "Is there a dress code? Smart casual?")
posts[:champagne_3] = Post.create!(event: events[:champagne], user: charlotte, content: "Smart casual is perfect. Elegant but relaxed vibes!")

# ─────────────────────────────────────────────────────────────────────────────
# SPARKLER posts (Marie's event - 3 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:sparkler_1] = Post.create!(event: events[:sparkler], user: users[:marie], content: "Sparklers ordered! It's going to be magical.")
posts[:sparkler_2] = Post.create!(event: events[:sparkler], user: users[:jean], content: "I'll bring some extra champagne bottles!")
posts[:sparkler_3] = Post.create!(event: events[:sparkler], user: users[:sophie], content: "Can we do a countdown together?")

# ─────────────────────────────────────────────────────────────────────────────
# CONCERT posts (Jean's event - 2 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:concert_1] = Post.create!(event: events[:concert], user: users[:jean], content: "The lineup is insane - Feu! Chatterton, Therapie Taxi, and more!")
posts[:concert_2] = Post.create!(event: events[:concert], user: users[:lucas], content: "Anyone want to grab dinner before the show?")

# ─────────────────────────────────────────────────────────────────────────────
# TENNIS posts (Emma's event - 3 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:tennis_1] = Post.create!(event: events[:tennis], user: users[:emma], content: "Courts are booked! Who wants to play doubles?")
posts[:tennis_2] = Post.create!(event: events[:tennis], user: users[:marie], content: "I haven't played in ages but I'm in!")
posts[:tennis_3] = Post.create!(event: events[:tennis], user: users[:sophie], content: "I'll bring the refreshments for after the games!")

# ─────────────────────────────────────────────────────────────────────────────
# BIRTHDAY posts (Charlotte's event - 2 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:birthday_1] = Post.create!(event: events[:birthday], user: charlotte, content: "So excited for this! Any dietary restrictions I should know about?")
posts[:birthday_2] = Post.create!(event: events[:birthday], user: users[:marie], content: "Can't wait to celebrate you! Already got the perfect gift.")

# ─────────────────────────────────────────────────────────────────────────────
# HALLOWEEN posts (Marc's event - 4 posts)
# ─────────────────────────────────────────────────────────────────────────────
posts[:halloween_1] = Post.create!(event: events[:halloween], user: users[:marc], content: "Working on the haunted house corner - it's going to be terrifying!")
posts[:halloween_2] = Post.create!(event: events[:halloween], user: users[:sophie], content: "Anyone want to coordinate group costumes?")
posts[:halloween_3] = Post.create!(event: events[:halloween], user: users[:jean], content: "I'm going as a vampire. Classic but effective!")
posts[:halloween_4] = Post.create!(event: events[:halloween], user: users[:thomas], content: "The cocktail menu is spooky good. Wait until you try the Witch's Brew!")

puts "  -> #{Post.count} posts ready"

# -----------------------------------------------------------------------------
# 7. Comments (Replies to posts) - Mix of authors and reply counts
# -----------------------------------------------------------------------------
puts "\n[6/7] Creating comments..."

# DISCO post replies (3 replies on dress code post)
Comment.create!(post: posts[:disco_1], user: users[:jean], content: "Sequins are a must! Going shopping this weekend.")
Comment.create!(post: posts[:disco_1], user: users[:emma], content: "I found the perfect gold jumpsuit!")
Comment.create!(post: posts[:disco_1], user: users[:thomas], content: "Do bell-bottoms count as glitter? Asking for a friend...")

# DISCO post replies (2 replies on song requests)
Comment.create!(post: posts[:disco_3], user: users[:marie], content: "Stayin' Alive, obviously!")
Comment.create!(post: posts[:disco_3], user: charlotte, content: "Adding Donna Summer to the list!")

# CHAMPAGNE post reply (1 reply)
Comment.create!(post: posts[:champagne_2], user: users[:marie], content: "I was wondering the same thing!")

# SPARKLER post replies (2 replies)
Comment.create!(post: posts[:sparkler_3], user: users[:marie], content: "Absolutely! Midnight countdown is a must.")
Comment.create!(post: posts[:sparkler_3], user: users[:lucas], content: "I'll set an alarm so we don't miss it!")

# CONCERT post replies (2 replies on dinner)
Comment.create!(post: posts[:concert_2], user: users[:marie], content: "Count me in for dinner!")
Comment.create!(post: posts[:concert_2], user: users[:sophie], content: "I know a great spot near La Cigale. 7pm?")

# TENNIS post replies (3 replies)
Comment.create!(post: posts[:tennis_1], user: users[:thomas], content: "I'll play! Fair warning, I'm rusty.")
Comment.create!(post: posts[:tennis_1], user: users[:lucas], content: "Same here. Let's be rusty together!")
Comment.create!(post: posts[:tennis_3], user: users[:emma], content: "Amazing! Lemonade would be perfect.")

# BIRTHDAY post replies (2 replies)
Comment.create!(post: posts[:birthday_1], user: users[:jean], content: "I'm vegetarian but I'm flexible!")
Comment.create!(post: posts[:birthday_1], user: users[:sophie], content: "No restrictions here. Can't wait!")

# HALLOWEEN post replies (3 replies on group costumes)
Comment.create!(post: posts[:halloween_2], user: users[:marie], content: "Let's do Addams Family!")
Comment.create!(post: posts[:halloween_2], user: users[:emma], content: "I call Wednesday!")
Comment.create!(post: posts[:halloween_2], user: users[:thomas], content: "I'll be Lurch then. Perfect for my height!")

# HALLOWEEN post replies (1 reply on Witch's Brew)
Comment.create!(post: posts[:halloween_4], user: users[:marc], content: "It's a secret recipe... you'll have to taste it to find out!")

puts "  -> #{Comment.count} comments ready"

# -----------------------------------------------------------------------------
# 8. Reactions (Likes on posts)
# -----------------------------------------------------------------------------
puts "\n[7/7] Creating reactions..."

reactions_data = [
  { post: posts[:disco_1], users: [users[:marie], users[:jean], users[:sophie], users[:emma], users[:thomas]] },
  { post: posts[:disco_2], users: [charlotte, users[:sophie], users[:thomas], users[:julie]] },
  { post: posts[:disco_4], users: [users[:marie], users[:jean], users[:emma], users[:lucas]] },
  { post: posts[:champagne_1], users: [users[:marie], users[:sophie], users[:emma], users[:marc]] },
  { post: posts[:sparkler_1], users: [users[:jean], users[:sophie], users[:emma], users[:thomas]] },
  { post: posts[:concert_1], users: [users[:marie], users[:lucas], users[:thomas], users[:julie]] },
  { post: posts[:tennis_1], users: [users[:marie], users[:jean], users[:sophie]] },
  { post: posts[:birthday_1], users: [users[:marie], users[:jean], users[:sophie], users[:emma]] },
  { post: posts[:halloween_1], users: [users[:sophie], users[:emma], users[:thomas], users[:julie], users[:claire]] },
  { post: posts[:halloween_2], users: [users[:marc], users[:jean], users[:thomas]] }
]

reactions_data.each do |data|
  data[:users].each do |user|
    Reaction.create!(post: data[:post], user: user)
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
puts "  Email:    charlotte@chacha.demo"
puts "  Password: password123"
puts "\nCharlotte's summary:"
puts "  Events she hosts:     #{Event.where(user: charlotte).count}"
puts "  Events hosted titles: #{Event.where(user: charlotte).pluck(:title).join(', ')}"
puts "  Her participations:   #{charlotte.participations.count} (should be 0 for Discover to work)"
puts "\nData created:"
puts "  - #{User.count} users"
puts "  - #{Event.count} events (#{Event.where(event_private: false).count} public, #{Event.where(event_private: true).count} private)"
puts "  - #{Participation.count} participations"
puts "  - #{Post.count} posts"
puts "  - #{Comment.count} comments"
puts "  - #{Reaction.count} reactions"
puts "  - #{Category.count} categories"
puts "  - #{Event.joins(:hero_image_attachment).count} events with hero images"
puts "=" * 60

# NOTE: The restoration of the original service has been REMOVED here.
