

import 'dart:math';

final class NicknameGenerator {
  NicknameGenerator._();

  static final random = Random();

  static String generate() {
     return adjectives[random.nextInt(adjectives.length)]
            + ' '
            + animals[random.nextInt(animals.length)];
  }
  
  //up to 10 letters long, one word
  //up to 1000 items each
  static const List<String> adjectives = [
    'Able', 'Active', 'Agile', 'Alert', 'Alive', 'Amused', 'Angry', 'Apt', 'Artful', 'Astute',
    'Aware', 'Bad', 'Bare', 'Basic', 'Bland', 'Bold', 'Brave', 'Brief', 'Bright', 'Broad',
    'Calm', 'Caring', 'Casual', 'Clean', 'Clear', 'Clever', 'Close', 'Cold', 'Cool', 'Cozy',
    'Crazy', 'Crisp', 'Crying', 'Cute', 'Damp', 'Dancing', 'Dark', 'Daring', 'Dear', 'Deep',
    'Dense', 'Dim', 'Direct', 'Diving', 'Dozing', 'Dry', 'Eager', 'Early', 'Easy', 'Elite',
    'Empty', 'Equal', 'Even', 'Fair', 'Famous', 'Fast', 'Fierce', 'Fine', 'Firm', 'Fit',
    'Fleet', 'Flying', 'Fond', 'Free', 'Fresh', 'Full', 'Funny', 'Gentle', 'Glad', 'Gliding',
    'Good', 'Grand', 'Great', 'Green', 'Happy', 'Hard', 'Harsh', 'Hiding', 'High', 'Hot',
    'Huge', 'Ideal', 'Idle', 'Inner', 'Joint', 'Jolly', 'Just', 'Keen', 'Kind', 'Large',
    'Late', 'Lazy', 'Leaping', 'Light', 'Like', 'Live', 'Lively', 'Lone', 'Long', 'Loud',
    'Loving', 'Low', 'Lucky', 'Mad', 'Main', 'Major', 'Making', 'Meek', 'Mild', 'Mini',
    'Minor', 'Moving', 'Naive', 'Near', 'Neat', 'Nice', 'Noble', 'Odd', 'Open', 'Pale',
    'Past', 'Pink', 'Plain', 'Playing', 'Plump', 'Pure', 'Quick', 'Quiet', 'Racing',
    'Rare', 'Raw', 'Ready', 'Real', 'Red', 'Rich', 'Riding', 'Ripe', 'Rising', 'Roaming',
    'Rolling', 'Rough', 'Round', 'Royal', 'Rude', 'Running', 'Safe', 'Same', 'Sharp',
    'Shining', 'Shy', 'Sick', 'Silent', 'Silly', 'Simple', 'Singing', 'Slim', 'Slow',
    'Small', 'Smart', 'Smooth', 'Soft', 'Solid', 'Solo', 'Sour', 'Spry', 'Stark',
    'Still', 'Sweet', 'Swift', 'Tall', 'Tame', 'Thick', 'Thin', 'Tiny', 'Tough',
    'True', 'Vast', 'Warm', 'Weak', 'Weird', 'Wild', 'Wise', 'Young', 'Zen', 'Zesty'
  ];

  static const List<String> animals = [
    'Ant', 'Ape', 'Asp', 'Bat', 'Bear', 'Bee', 'Bird', 'Boar', 'Boxer', 'Bull',
    'Bulldog', 'Cat', 'Chick', 'Clam', 'Collie', 'Colt', 'Cow', 'Crab', 'Crane', 'Crow',
    'Deer', 'Dingo', 'Dodo', 'Dog', 'Dove', 'Duck', 'Eagle', 'Eel', 'Elk', 'Emu',
    'Fawn', 'Finch', 'Fish', 'Fox', 'Frog', 'Goat', 'Goose', 'Gull', 'Hare', 'Hawk',
    'Hen', 'Hog', 'Horse', 'Husky', 'Ibex', 'Ibis', 'Jay', 'Kiwi', 'Koi', 'Lab',
    'Lark', 'Lion', 'Lynx', 'Malamute', 'Mink', 'Mole', 'Moth', 'Mouse', 'Mule',
    'Newt', 'Orca', 'Owl', 'Ox', 'Panda', 'Perch', 'Pig', 'Pike', 'Pit Bull',
    'Pony', 'Pug', 'Puma', 'Quail', 'Ram', 'Rat', 'Raven', 'Seal', 'Shark',
    'Sheep', 'Shiba', 'Shrew', 'Skunk', 'Sloth', 'Snail', 'Snake', 'Stag',
    'Swan', 'Swift', 'Teal', 'Terrier', 'Tern', 'Toad', 'Tiger', 'Trout',
    'Tuna', 'Vole', 'Wasp', 'Whale', 'Wolf', 'Worm', 'Yak', 'Zebra'
  ];


}