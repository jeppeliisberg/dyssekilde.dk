# Rental Houses Resource Design

## Overview

Add a Spina resource for rental houses that displays as a collection on the site and expands to individual house pages.

## Decision: Use Spina Resources

Resources were chosen over alternatives (Repeater parts, custom Rails models) because:
- Each house gets its own URL (`/houses/elmegade-42`)
- Dedicated admin section for editors
- Built-in ordering by street address
- Simple for a small collection (1-5 houses)

## Data Structure

**Page title = Street address** (e.g., "Elmegade 42")
- Used for admin listing, sorting, and URL slug generation
- `order_by: "title"` sorts houses alphabetically by address

**Parts:**

| Part Name | Type | Purpose |
|-----------|------|---------|
| `house_name` | Line | Friendly name ("Cozy Cottage") |
| `house_description` | Text | Rich text description |
| `house_images` | ImageCollection | Photo gallery |
| `house_bedrooms` | Line | Number of bedrooms |
| `house_bathrooms` | Line | Number of bathrooms |
| `house_max_guests` | Line | Maximum guests |
| `house_sqm` | Line | Square meters |
| `house_pricing` | Line | Free text pricing info |
| `house_contact` | MultiLine | Contact info (name, phone, email) |

## Theme Configuration

```ruby
# Add to theme.parts
{ name: "house_name", title: "House Name", hint: "Friendly name like 'Cozy Cottage'", part_type: "Spina::Parts::Line" },
{ name: "house_description", title: "Description", part_type: "Spina::Parts::Text" },
{ name: "house_images", title: "Photos", part_type: "Spina::Parts::ImageCollection" },
{ name: "house_bedrooms", title: "Bedrooms", part_type: "Spina::Parts::Line" },
{ name: "house_bathrooms", title: "Bathrooms", part_type: "Spina::Parts::Line" },
{ name: "house_max_guests", title: "Max Guests", part_type: "Spina::Parts::Line" },
{ name: "house_sqm", title: "Square Meters", part_type: "Spina::Parts::Line" },
{ name: "house_pricing", title: "Pricing", part_type: "Spina::Parts::Line" },
{ name: "house_contact", title: "Contact", part_type: "Spina::Parts::MultiLine" }

# Add to theme.view_templates
{
  name: "house",
  title: "House",
  parts: %w[house_name house_description house_images house_bedrooms house_bathrooms house_max_guests house_sqm house_pricing house_contact]
}

# Add to theme.resources
{ name: "houses", label: "Rental Houses", view_template: "house", order_by: "title" }
```

## Views Required

1. **Individual house page:** `app/views/default/pages/house.html.erb`
2. **Collection display:** Fetch houses via `Spina::Resource.find_by(name: "houses").pages`

## URL Structure

- Collection: Rendered on any page using resource query
- Individual: `/houses/<slug>` (e.g., `/houses/elmegade-42`)

## Not Included

- Amenities list (not needed)
- Location/map (not needed)
- Booking/availability (informational only)
- Search/filtering (small collection)
