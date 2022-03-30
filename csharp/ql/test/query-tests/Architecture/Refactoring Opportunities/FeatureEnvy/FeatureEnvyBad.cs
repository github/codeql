using System;

class Bad
{
    class Item
    {
        public bool IsOutOfStock;
        public decimal Price;
        public decimal Tax;
        public bool IsOnSale;
        public decimal SaleDiscount;
    }

    class Basket
    {
        decimal GetTotalPrice(Item i)
        {
            if (i.IsOutOfStock)
                throw new Exception("Item ${i} is out of stock.");
            var price = i.Price + i.Tax;
            if (i.IsOnSale)
                price = price - i.SaleDiscount * price;
            return price;
        }
    }
}
