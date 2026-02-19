-- Supabase Database Setup for Blog Application
-- Run this SQL in your Supabase SQL Editor to create the required tables and storage

-- Create the blogs table
CREATE TABLE IF NOT EXISTS blogs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create an index on created_at for better performance
CREATE INDEX IF NOT EXISTS idx_blogs_created_at ON blogs(created_at DESC);

-- Create a function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create a trigger to automatically update updated_at
CREATE TRIGGER update_blogs_updated_at 
    BEFORE UPDATE ON blogs 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS) on the blogs table
ALTER TABLE blogs ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows all operations (for demo purposes)
-- In production, you should create more restrictive policies
CREATE POLICY "Enable all operations for all users" ON blogs
    FOR ALL USING (true) WITH CHECK (true);

-- Create the storage bucket for blog images
-- Note: This needs to be created via Supabase Dashboard or using the storage API
-- Bucket name: "blog-images"
-- Make it public so images can be accessed without authentication

-- Storage policy for blog-images bucket
-- Allow all users to upload and read images (for demo purposes)
-- In production, you should create more restrictive policies

-- You can create the bucket and policies using the following JavaScript in Supabase Dashboard Console:
/*
// Create bucket
const { data, error } = await supabase.storage.createBucket('blog-images', {
  public: true,
  allowedMimeTypes: ['image/*'],
  fileSizeLimit: 5242880, // 5MB
});

// Create policy for uploads
const { data: uploadPolicy, error: uploadError } = await supabase.storage.from('blog-images').createPolicy('public-uploads', {
  role: 'anon',
  allow: ['INSERT'],
  filter: {}
});

// Create policy for reads
const { data: readPolicy, error: readError } = await supabase.storage.from('blog-images').createPolicy('public-reads', {
  role: 'anon',
  allow: ['SELECT'],
  filter: {}
});
*/

-- Sample data (optional)
INSERT INTO blogs (title, content, image_url) VALUES 
('Welcome to Flutter Blog', 'This is a sample blog post created to demonstrate the Flutter blog application with Supabase integration. The app showcases proper use of StatefulWidget lifecycle methods and full CRUD operations.', null),
('Understanding Flutter Lifecycle', 'Flutter widgets have a well-defined lifecycle. Understanding when initState(), didChangeDependencies(), build(), and dispose() are called is crucial for building efficient applications.', null),
('Supabase + Flutter', 'Supabase provides an excellent backend-as-a-service solution for Flutter applications. With features like authentication, real-time database, and storage, it''s perfect for rapid development.', null);

-- Verify the setup
SELECT * FROM blogs ORDER BY created_at DESC;
