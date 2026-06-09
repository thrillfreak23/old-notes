#!/usr/bin/env python3

import random

# Define consonant and vowel sets
consonants = ['p', 't', 'ch', 'k', 'b', 'd', 'j', 'g', 'm', 'n', 'ng', 'r', 'l', 'h', 'w', 'y', 's', 'z', 'sh', 'zh', 'th', 'dh', 'ts']
vowels = ['a', 'e', 'i', 'o', 'u']

def generate_syllable():
  """Generates a single syllable (CVC)."""
  return random.choice(consonants) + random.choice(vowels) + random.choice(consonants)

def generate_word_root():
  """Generates a word root according to the specified rules."""
  syllable_count = random.choices([1, 2, 3], weights=[0.7, 0.2, 0.1])[0] 
  root = ""
  for _ in range(syllable_count):
    root += generate_syllable()
  return root

# Generate and print a few example word roots
for _ in range(10):
  print(generate_word_root())
