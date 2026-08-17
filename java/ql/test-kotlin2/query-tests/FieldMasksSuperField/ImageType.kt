sealed class ImageType(open val width: Int, open val height: Int) {
    object Portrait : ImageType(78, 98)
    object Square : ImageType(78, 78)
    object PortraitLarge : ImageType(163, 205)
}
