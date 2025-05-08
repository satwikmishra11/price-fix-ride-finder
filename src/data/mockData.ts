
import { RideData } from '../components/RideOptions';

// Generate random price between min and max
const getRandomPrice = (min: number, max: number) => {
  return Math.floor(Math.random() * (max - min + 1) + min);
};

// Generate random ETA between 3 and 15 minutes
const getRandomETA = () => {
  return Math.floor(Math.random() * 12) + 3;
};

// Generate mock ride data with random but realistic prices
export const getMockRideData = (pickup: string, dropoff: string): RideData[] => {
  // Base price between 100 and 250
  const basePrice = getRandomPrice(100, 250);
  
  // Generate prices for each provider with some variation
  const uberPrice = basePrice + getRandomPrice(-20, 20);
  const olaPrice = basePrice + getRandomPrice(-30, 10);
  const rapidoPrice = basePrice + getRandomPrice(-40, 5);
  
  return [
    {
      provider: "uber",
      price: uberPrice,
      estimatedTime: getRandomETA(),
    },
    {
      provider: "ola",
      price: olaPrice,
      estimatedTime: getRandomETA(),
    },
    {
      provider: "rapido",
      price: rapidoPrice,
      estimatedTime: getRandomETA(),
    }
  ];
};
