
import { RideData } from "../components/RideOptions";

// Find the ride with the lowest price
export const findCheapestRide = (rides: RideData[]): RideData => {
  return rides.reduce((cheapest, current) => 
    current.price < cheapest.price ? current : cheapest
  , rides[0]);
};

// Calculate the savings compared to the most expensive option
export const calculateSavings = (rides: RideData[]): number => {
  if (!rides || rides.length < 2) return 0;
  
  const cheapest = findCheapestRide(rides);
  const mostExpensive = rides.reduce((max, current) => 
    current.price > max.price ? current : max
  , rides[0]);
  
  return mostExpensive.price - cheapest.price;
};

// Get price difference percentage between two rides
export const getPriceDifferencePercentage = (price1: number, price2: number): number => {
  return Math.round(((price1 - price2) / price1) * 100);
};
