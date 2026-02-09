namespace :demo do
  desc "Seed presentation demo users and dues data (explicit/manual only)"
  task seed: :environment do
    unless ENV["DEMO_SEED"] == "true"
      abort "Refusing to seed demo data. Re-run with DEMO_SEED=true."
    end

    load Rails.root.join("db/seeds/10_presentation_demo.rb")
  end
end
