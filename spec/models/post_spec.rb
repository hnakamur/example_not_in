require 'spec_helper'

describe Post do
  it do
    expect(FactoryGirl.create(:post)).to be_a Post
  end

  context "with 15 posts" do
    before do
      15.times do
        FactoryGirl.create(:post)
      end
    end
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }

    it { expect(Post.count).to eq(15) }

    it "no voted posts" do
      expect(Post.voted_by(user.id).count).to eq(0)
    end
    it "15 not_voted posts" do
      expect(Post.not_voted_by(user.id).count).to eq(15)
    end

    context "with posts voted by another_user" do
      before do
        Post.all.each do |post|
          another_user.vote_for(post)
        end
      end
      context "user" do
        it "no voted posts" do
          expect(Post.voted_by(user.id).count).to eq(0)
        end
        it "15 not_voted posts" do
          expect(Post.not_voted_by(user.id).count).to eq(15)
        end
      end
      context "another_user" do
        it "15 voted posts" do
          expect(Post.voted_by(another_user.id).count).to eq(15)
        end
        it "no not_voted posts" do
          expect(Post.not_voted_by(another_user.id).count).to eq(0)
        end
      end
    end

    context "with posts voted by both" do
      before do
        Post.all.each do |post|
          user.vote_for(post)
          another_user.vote_for(post)
        end
      end
      context "user" do
        it "15 voted posts" do
          expect(Post.voted_by(user.id).count).to eq(15)
        end
        it "0 not_voted posts" do
          expect(Post.not_voted_by(user.id).count).to eq(0)
        end
      end
      context "another_user" do
        it "15 voted posts" do
          expect(Post.voted_by(another_user.id).count).to eq(15)
        end
        it "no not_voted posts" do
          expect(Post.not_voted_by(another_user.id).count).to eq(0)
        end
      end
    end
  end
end
