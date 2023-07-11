class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: " ",
    image: "assets/images/on-boarding1.png",
    desc:
        "  We provide electronic parts, whether new or used, for engineering students' graduation projects",
  ),
  OnboardingContents(
    title: " ",
    image: "assets/images/on-boarding2.png",
    desc:
        "We provide students with ideas for graduation projects, showing the pieces of each project",
  ),
  OnboardingContents(
    title: " ",
    image: "assets/images/on-boarding3.png",
    desc:
        "We provide parts that are not available in the sector by shipping them from abroad",
  ),
];
