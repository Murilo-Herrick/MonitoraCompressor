part of '_widgets_lib.dart';

class ProfileInfoRow extends StatelessWidget {
  final int posts;
  final int followers;
  final int following;

  const ProfileInfoRow({
    super.key,
    required this.posts,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    final List<ProfileInfoItem> items = [
      ProfileInfoItem("Posts", posts),
      ProfileInfoItem("Followers", followers),
      ProfileInfoItem("Following", following),
    ];

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    if (items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(item.title, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}
